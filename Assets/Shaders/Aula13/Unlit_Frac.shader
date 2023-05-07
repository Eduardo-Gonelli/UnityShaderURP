Shader "Aula13/Unlit_Frac"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Size ("Size", Range(0.0, 0.5)) = 0.3
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
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Size;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);                
                return o;
            }
            // toda a transformacao e feita por aqui
            fixed4 frag(v2f i) : SV_Target
            {
                i.uv *= 3; // 3 controla a quantidade de repetições
                float2 fuv = frac(i.uv);
                float circle = length(fuv - 0.5);
                float wCircle = floor(_Size / circle);
                fixed4 col = tex2D(_MainTex, fuv); // textura
                return col * float4(wCircle.xxx, 1); // col recebe textura
            }
            ENDCG
        }
    }
}
