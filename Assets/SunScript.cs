using UnityEngine;

public class DayNightCycle : MonoBehaviour
{
    public Light sun;
    public float dayLengthInSeconds = 2f;
    [Range(0f, 1f)] public float timeOfDay = 0f;
    public bool autoAdvance = true;
    public float maxSunIntensity = 1.2f;
    public Color dayAmbientColor = new Color(0.6f, 0.6f, 0.7f);
    public Color nightAmbientColor = new Color(0.05f, 0.05f, 0.10f);

    void Update()
    {
        if (autoAdvance && dayLengthInSeconds > 0f)
        {
            timeOfDay += Time.deltaTime / dayLengthInSeconds;
            if (timeOfDay > 1f) timeOfDay -= 1f;
        }

        float sunAngle = timeOfDay * 360f - 90f;
        sun.transform.rotation = Quaternion.Euler(sunAngle, 0f, 0f);

        Vector3 sunDir = -sun.transform.forward;
        float height = Mathf.Clamp01(Vector3.Dot(sunDir, Vector3.up));
        float sunFactor = Mathf.SmoothStep(0f, 1f, height);

        sun.intensity = sunFactor * maxSunIntensity;
        RenderSettings.ambientLight = Color.Lerp(nightAmbientColor, dayAmbientColor, sunFactor);
    }
}

