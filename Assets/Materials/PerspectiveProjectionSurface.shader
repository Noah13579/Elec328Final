Shader "Custom/URP_PerspectiveProjectionSurface"
{
    Properties
    {
        [MainTexture] _UserCamTex("User Camera Texture", 2D) = "white" {}
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

            // Core URP includes
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            // UserCam texture + sampler
            TEXTURE2D(_UserCamTex);
            SAMPLER(sampler_UserCamTex);

            // Matrix passed from C# (GPU projection * worldToCamera)
            float4x4 _UserCamW2C;

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

                // Convert from object space to world space
                float3 worldPos = TransformObjectToWorld(IN.positionOS.xyz);

                // Project with User Camera matrix
                float4 clipPos = mul(_UserCamW2C, float4(worldPos, 1.0));

                // Output position for drawing quad normally
                OUT.positionHCS = TransformWorldToHClip(worldPos);

                // Output the projection
                OUT.projPos = clipPos;

                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                float2 uv = IN.projPos.xy / IN.projPos.w;

                // Normalize the uvs
                uv = uv * 0.5 + 0.5;

                return SAMPLE_TEXTURE2D(_UserCamTex, sampler_UserCamTex, uv);
            }

            ENDHLSL
        }
    }
}
