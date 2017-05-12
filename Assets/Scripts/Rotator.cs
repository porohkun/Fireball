
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotator : MonoBehaviour
{
    private Renderer _renderer;
    [SerializeField]
    private Vector2 _speed;
    [SerializeField]
    private float _maxSpeedOffset;
    [SerializeField]
    private float _minSpeedOffsetTime=0.2f;
    [SerializeField]
    private float _maxSpeedOffsetTime=0.5f;

    private Vector2 _offset;
    private Vector2 _speedOffset;
    private Vector2 _speedStartOffset;
    private Vector2 _speedTargetOffset;
    private float _offsetTime;
    private float _startOffset;

    void Start()
    {
        _renderer = GetComponent<Renderer>();
    }

    void Update()
    {
        if (_offsetTime + _startOffset <= Time.realtimeSinceStartup)
        {
            _speedTargetOffset = new Vector2(Random.Range(-_maxSpeedOffset, _maxSpeedOffset), Random.Range(-_maxSpeedOffset, _maxSpeedOffset));
            _startOffset = Time.realtimeSinceStartup;
            _offsetTime = Random.Range(_minSpeedOffsetTime, _maxSpeedOffsetTime);
            _speedStartOffset = _speedOffset;
        }

        _speedOffset = Vector2.Lerp(_speedStartOffset, _speedTargetOffset, (Time.realtimeSinceStartup - _startOffset) / _offsetTime);

        _offset += (_speed + _speedOffset) * Time.deltaTime;
        _renderer.material.SetFloat("_XOffset", _offset.x);
        _renderer.material.SetFloat("_YOffset", _offset.y);
    }
}
