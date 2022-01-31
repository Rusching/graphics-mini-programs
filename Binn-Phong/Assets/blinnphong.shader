Shader "Custom/blinnphong"
{
    Properties {
		_Diffuse ("Diffuse", Color) = (1, 1, 1, 1)
		_Specular ("Specular", Color) = (1, 1, 1, 1)
		_Gloss ("Gloss", Range(0.0, 1000)) = 30
	}
	SubShader {
		Pass { 
			Tags { "LightMode"="ForwardAdd" }
		
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			
			#define POINT			

			#include "Lighting.cginc"

			fixed4 _Diffuse;
			fixed4 _Specular;
			float _Gloss;
			
			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};
			
			struct v2f {
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
			};
			
			v2f vert(a2v v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				return o;
			}
			
			fixed4 frag(v2f i) : SV_Target {
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 worldLightDirection = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
				fixed3 bisector = normalize(worldLightDirection + viewDirection);
				float3 dis=i.worldPos-unity_LightPosition[0].xyz;
				float r=dis.x * dis.x + dis.y * dis.y + dis.z * dis.z;
				
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 diffuse =_LightColor0.rgb*_Diffuse.rgb /r* max(0, dot(worldNormal, worldLightDirection));
				fixed3 specular = _LightColor0.rgb*_Specular.rgb/r* pow(max(0, dot(worldNormal, bisector)), _Gloss);

				return fixed4(ambient + diffuse + specular, 1.0);
			}
			
			ENDCG
		}
	} 
	FallBack "Specular"
}
