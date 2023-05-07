Shader "Aula13/Unlit_Zoom"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        // propriedade de controle do zoom
        _Zoom ("Zoom", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag            
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Zoom; // link entre ShaderLab e Cg

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // ceil para as coordenadas u e v
                float u = ceil(i.uv.x) * 0.5;
                float v = ceil(i.uv.y) * 0.5;
                // calculo Lerp (interpolado) entre as variaveis
                float uLerp = lerp(u, i.uv.x, _Zoom);
                float vLerp = lerp(v, i.uv.y, _Zoom);
                // adiciona os novos valores a textura
                fixed4 col = tex2D(_MainTex, float2(uLerp, vLerp));                
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
