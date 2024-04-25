Shader "Aula12/Unlit_Tan"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        // propriedades utilizadas
        _Color ("Color", Color) = (1, 1, 1, 1)
        _Sections ("Sections", Range(2, 10)) = 10
    }
    SubShader
    {
        // como usamos transparencia, muda tag e blend
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
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
            float4 _Color;    // link do shaderlab _Color com o HLSL
            float _Sections;  // o mesmo para o _Sections

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
                // calculo do abs da tangente com um clamp m�nimo de 0 e m�ximo de 1
                // utilizamos tamb�m o _Time para um efeito de tv antiga
                float4 tanCol = clamp(0, abs(tan((i.uv.y - _Time) * _Sections)), 1);
                tanCol *= _Color;
                fixed4 col = tex2D(_MainTex, i.uv) * tanCol;                
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
