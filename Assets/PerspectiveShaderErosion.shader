Shader "Custom/URP_PerspectiveProjectionSurface_Erosion"
{
    Properties
    {
        [MainTexture] _UserCamTex("User Camera Texture", 2D) = "white" {}
        _BaseColor("Base Color", Color) = (1,1,1,1)
        _ErodedColor("Eroded Color", Color) = (0.2,0.2,0.2,1)
        _ErosionStrength("Erosion Strength", Range(0,1)) = 1
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

            TEXTURE2D(_UserCamTex);
            SAMPLER(sampler_UserCamTex);

            float4 _BaseColor;
            float4 _ErodedColor;
            float _ErosionStrength;

            float4x4 _UserCamW2C;

            struct Attributes {
                float4 positionOS : POSITION;
            };

            struct Varyings {
                float4 positionHCS : SV_POSITION;
                float4 projPos : TEXCOORD0;
            };

            Varyings vert(Attributes IN)
            {
                Varyings OUT;

                float3 worldPos = TransformObjectToWorld(IN.positionOS.xyz);

                // apply projection
                float4 clipPos = mul(_UserCamW2C, float4(worldPos, 1));
                OUT.projPos = clipPos;

                OUT.positionHCS = TransformWorldToHClip(worldPos);

                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                float2 uv = IN.projPos.xy / IN.projPos.w;
                uv = uv * 0.5 + 0.5;

                // projected camera sample
                float3 camSample = SAMPLE_TEXTURE2D(_UserCamTex, sampler_UserCamTex, uv).rgb;

                // simple grayscale = erosion map
                float erosion = dot(camSample, float3(0.299, 0.587, 0.114));

                // erosion strength multiplier
                erosion *= _ErosionStrength;

                // final color blend
                float3 finalColor = lerp(_BaseColor.rgb, _ErodedColor.rgb, erosion);

                return float4(finalColor, 1);
            }

            ENDHLSL
        }
    }
}
