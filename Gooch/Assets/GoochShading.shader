Shader "GoochShading"{
    Properties{
        _Surface_Color ("Surface Color",Color)=(1,1,1,0)
        _Warm_Color ("Warm Color",Color)=(0.3,0.3,0.0,0)
        _Cool_Color ("Cool Color",Color)=(0,0,0.55,0)
        _Highlight_Color ("Highlight Color",Color)=(1,1,1,0)
    }
    SubShader{
        Tags{"RenderType"="Opaque" "Queue"="Geometry"}

        pass{
            Tags{"LightMode"="ForwardBase"}
            CGPROGRAM
            #pragma multi_compile_fwdbase
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"

            fixed4 _Surface_Color;
            fixed4 _Warm_Color;
            fixed4 _Cool_Color;
            fixed4 _Highlight_Color;

            struct a2v{
                float4 vertex:POSITION;
                float3 normal:NORMAL;
            };
            struct v2f{
                float4 pos:SV_POSITION;
                float3 worldPos:TEXCOORD1;
                float3 worldnormal:TEXCOORD2;
            };

            v2f vert(a2v v){
                v2f o;
                o.pos=UnityObjectToClipPos(v.vertex);
                o.worldnormal=UnityObjectToWorldNormal(v.normal);
                o.worldPos=mul(unity_ObjectToWorld,v.vertex).xyz;
                return o;
            }

            fixed4 frag(v2f o):SV_TARGET{
                float3 LightDirection=normalize(UnityWorldSpaceLightDir(o.worldPos));
                float3 ViewDirection=normalize(UnityWorldSpaceViewDir(o.worldPos));
                float t=0.5*(dot(o.worldnormal,LightDirection)+1);
                float3 r=2*dot(o.worldnormal,LightDirection)*o.worldnormal-LightDirection;
                float s=saturate(100*dot(r,ViewDirection)-97);

                fixed4 res=s*_Highlight_Color+(1-s)*(t*(_Warm_Color+0.25*_Surface_Color)+(1-t)*(_Cool_Color+0.25*_Surface_Color));
                return res;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
