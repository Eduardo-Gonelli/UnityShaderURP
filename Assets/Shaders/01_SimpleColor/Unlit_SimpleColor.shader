Shader "CG_Aulas/01_Unlit_SimpleColor"
{	
	Properties
	{		
		_MainTex("Texture", 2D) = "white" {}	
		_Color("Color", Color) = (1, 1, 1, 1)
	}	
	SubShader
	{
		Tags 
		{ 
			"RenderType" = "Opaque"
			"RenderPipeline" = "UniversalRenderPipeline"
		}
		LOD 100		
		Pass
		{			
			HLSLPROGRAM			
			#pragma vertex vert
			#pragma fragment frag			
			#pragma multi_compile_fog	
			
			#include "HLSLSupport.cginc"	
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

			
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};
			
			struct v2f
			{
				float2 uv : TEXCOORD0;
				//UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};
			
			sampler2D _MainTex;
			float4 _Color;
			
			
			
			float4 _MainTex_ST;
			
			v2f vert(appdata v)
			{
				v2f o;
				//o.vertex = UnityObjectToClipPos(v.vertex);
				o.vertex = TransformObjectToHClip(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);				
				//UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			half4 frag(v2f i) : SV_Target
			{				
				half4 col = tex2D(_MainTex, i.uv);								
				return col * _Color;
			}
			ENDHLSL
        }
	}
}