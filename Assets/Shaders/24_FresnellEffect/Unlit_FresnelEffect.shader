Shader "CG_Aulas/24_Unlit_FresnelEffect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _FresnelPow ("Fresnel Power", Range(1, 5)) = 1
        _FresnelInt ("Fresnel Intensity", Range(0, 1)) = 1
        _Color ("Color", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}
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
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;                
                float4 vertex : SV_POSITION;
                float3 normal_world : TEXCOORD1;
                float3 vertex_world : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _FresnelPow;
            float _FresnelInt;
            float4 _Color;

            void unity_FresnelEffect_float
            (
                in float3 normal, 
                in float3 viewDir, 
                in float power, 
                out float Out)
            {
                Out = pow((1 - saturate(dot(normal, viewDir))), power);
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal_world = normalize(mul(unity_ObjectToWorld, float4(v.normal, 0))).xyz;
                o.vertex_world = mul(unity_ObjectToWorld, v.vertex);                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {                
                fixed4 col = tex2D(_MainTex, i.uv);
                float3 normal = i.normal_world;
                float3 viewDir = normalize(_WorldSpaceCameraPos - i.vertex_world);     
                float fresnel = 0;
                unity_FresnelEffect_float(normal, viewDir, _FresnelPow, fresnel);
                //_Color *= fresnel;
                //col += _Color * _FresnelInt;                
                col += fresnel * _FresnelInt;

                return col;
            }
            ENDCG
        }
    }
}
