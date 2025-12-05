Shader "Custom/URP_PerspectiveProjectionSurface"
{
    Properties
    {
        [MainTexture] _WeatheredTex("Weathered Texture", 2D) = "white" {}
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline"="UniversalPipeline" }

        Pass
        {
            ZWrite Off
            Cull Off

            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            // Texture and sampler
            TEXTURE2D(_WeatheredTex);
            SAMPLER(sampler_WeatheredTex);

            // Weathered camera worldToCamera * GPU projection
            float4x4 _WeatheredW2C;

            struct Attributes
            {
                float4 positionOS : POSITION;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float4 projPos : TEXCOORD0;
            };

            Varyings vert(Attributes IN)
            {
                Varyings OUT;

                float3 worldPos = TransformObjectToWorld(IN.positionOS.xyz);

                float4 clipPos = mul(_WeatheredW2C, float4(worldPos, 1.0));

                OUT.positionHCS = TransformWorldToHClip(worldPos);
                OUT.projPos = clipPos;

                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                float2 uv = IN.projPos.xy / IN.projPos.w;

                uv = uv * 0.5 + 0.5;

                return SAMPLE_TEXTURE2D(_WeatheredTex, sampler_WeatheredTex, uv);
            }

            ENDHLSL
        }
    }
}
