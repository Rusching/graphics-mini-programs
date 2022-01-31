Shader "Custom/bump"
{
    Properties
    {
        _MainTex ("Main Tex", 2D) = "white" {}
        _BumpMap("Normal Map", 2D) = "bump"{}
        _BumpScale ("Bump Scale", Float) = 0.5
        _Specular ("Specular", Color) = (1, 1, 1, 1)
        _Gloss ("Gloss", Range(1.0, 1000)) = 30
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _BumpMap;
            float4 _BumpMap_ST;
            float _BumpScale;
            fixed4 _Specular;
            float _Gloss;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float4 texture_coordinate : TEXCOORD0;
            };

            struct v2f
            {
                float4 position : SV_POSITION;
                float4 uv : TEXCOORD0;
                float3 LightDirection :TEXCOORD1;
                float3 ViewDirection : TEXCOORD2;
            };

            v2f vert (a2v v)
            {
                v2f o;
                o.position = UnityObjectToClipPos(v.vertex);

                o.uv.xy = TRANSFORM_TEX(v.texture_coordinate, _MainTex);
                o.uv.zw = TRANSFORM_TEX(v.texture_coordinate, _BumpMap);

                TANGENT_SPACE_ROTATION;

                o.LightDirection = mul(rotation, ObjSpaceLightDir(v.vertex));
                o.ViewDirection = mul(rotation, ObjSpaceViewDir(v.vertex));

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 TangentLightDirection = normalize(i.LightDirection);
                fixed3 TangentViewDirection = normalize(i.ViewDirection);

                fixed4 BumpValue = tex2D(_BumpMap, i.uv.zw);
                fixed3 TangentNormal = UnpackNormal(BumpValue);

                TangentNormal.xy *= _BumpScale;
                TangentNormal.z = sqrt(1.0 - (TangentNormal.x*TangentNormal.x+TangentNormal.y*TangentNormal.y));

                fixed3 albedo = tex2D(_MainTex, i.uv).rgb;
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(TangentNormal, TangentLightDirection));
                fixed3 bisector = normalize(TangentLightDirection + TangentViewDirection);
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(TangentNormal, bisector)), _Gloss);
                return fixed4(ambient + diffuse + specular, 1.0);
            }
            ENDCG
        }
    }
}
