Shader "Unlit/Meditation"
{
    Properties
    {
        _Color1 ("Color 1", Color) = (1, 1, 1, 1)
        _Color2 ("Color 2", Color) = (0, 0, 0, 1)
        _Scale ("Time Scale", Range(0.001, 0.1)) = 0.01
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
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            fixed4 _Color1;
            fixed4 _Color2;
            fixed _Scale;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }
            
            fixed4 colorMap(fixed x) {
                fixed adj = x * 2;
                if (adj < 1) {
                    return lerp(_Color1, _Color2, sin(_Time * _Scale) * 0.5 + 0.5);
                } else {
                    return lerp(_Color1, _Color2, sin((_Time + 20) * _Scale) * 0.5 + 0.5);
                }
            }
            
            fixed sinTime() {
                fixed x = sin(_Time) * 0.5 + 1.5;
                if (x < 0.2) {
                    return 0.2;
                } else if (x > 0.9) {
                    return 0.9;
                } else {
                    return x;
                }
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return lerp(colorMap(0), colorMap(1), smoothstep(0.1, sinTime(), frac(i.uv.x)));
            }
            ENDCG
        }
    }
}
