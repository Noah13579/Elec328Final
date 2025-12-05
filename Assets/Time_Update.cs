using UnityEngine;

public class Time_Update : MonoBehaviour
{
    private Material material;
    private static readonly int Growth = Shader.PropertyToID("_Growth");
    private static readonly int Sharpness = Shader.PropertyToID("_Sharpness");
    private float duration = 30f;
    private float startValue = 0f;
    private float endValue = 0.2f;
    private float elapsedTime = 0f;
    private float sharpnessMultiplier = 10;

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        elapsedTime = 0f;
    }

    // Update is called once per frame
    void Update()
    {
        if (elapsedTime < duration)
        {
            elapsedTime += Time.deltaTime;
            float t = elapsedTime / duration;
            float currentValue = Mathf.Lerp(startValue, endValue, t);
            Shader.SetGlobalFloat(Growth, currentValue);
            Shader.SetGlobalFloat(Sharpness, currentValue*sharpnessMultiplier);
        }
    }
}

