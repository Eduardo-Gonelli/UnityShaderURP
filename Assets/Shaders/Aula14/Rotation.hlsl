void Rotation_float(in float3 vertex, in float _Speed, out float3 Out)
{
    float c = cos(_Time.y * _Speed);
    float s = sin(_Time.y * _Speed);

    float3x3 m = float3x3(
        c, 0, s,
        0, 1, 0,
        -s, 0, c
        );
    Out = mul(m, vertex);
}

