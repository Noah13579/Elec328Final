using UnityEngine;

public class PerspectiveProjectionFeed : MonoBehaviour
{
    public Camera userCam;
    public Material targetMaterial;
    public RenderTexture userCamTex;

    void Update()
    {
        // Prepare GPU-ready projection matrix
        Matrix4x4 gpuProj = GL.GetGPUProjectionMatrix(userCam.projectionMatrix, true);

        // Build world-to-camera clip matrix
        Matrix4x4 userCamW2C = gpuProj * userCam.worldToCameraMatrix;

        // Feed to shader
        targetMaterial.SetMatrix("_UserCamW2C", userCamW2C);
        targetMaterial.SetTexture("_UserCamTex", userCamTex);
    }
}
