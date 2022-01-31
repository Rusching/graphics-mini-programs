using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[RequireComponent(typeof(LineRenderer))]
public class bezier : MonoBehaviour
{

    public Transform[] controlPoint;
    public LineRenderer lineRenderer;

    private int layerOrder = 0;
    //取样数
    private int _segmentNum = 5000;
    void Start()
    {
        if (!lineRenderer)
        {
            lineRenderer = GetComponent<LineRenderer>();
        }
        lineRenderer.sortingLayerID = layerOrder;
    }
    void Update()
    {
        DrawCurve();
    }
    //画曲线
    void DrawCurve()
    {
        for (int i = 1; i < _segmentNum; i++)
        {
            float t = i / (float)_segmentNum;
            int nodeIndex = 0;
            Vector3 pixel = CalculateCubicBezierPoint(t, controlPoint[nodeIndex].position, controlPoint[nodeIndex + 1].position,
                controlPoint[nodeIndex + 2].position, controlPoint[nodeIndex + 3].position);
            lineRenderer.positionCount = i;
            lineRenderer.SetPosition(i - 1, pixel);
        }
    }
    //获得贝塞尔曲线的数组
    Vector3 CalculateCubicBezierPoint(float t, Vector3 p0, Vector3 p1, Vector3 p2, Vector3 p3)
    {
        float u = 1 - t;
        float uu = u * u;
        float uuu = u * u * u;
        float tt = t * t;
        float ttt = t * t * t;
        Vector3 p = p0 * uuu;
        p += 3 * p1 * t * uu;
        p += 3 * p2 * tt * u;
        p += p3 * ttt;
        return p;

    }
}