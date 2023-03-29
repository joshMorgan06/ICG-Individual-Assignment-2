Shader "Custom/Outline"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}

        _OutlineColor("OutlineColor", Color) = (0, 0, 0, 1)
        _OutlineSize("OutlineSize", Range(0.002, 5)) = 1
        [Toggle] _ShowOutline("Show Outline?", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
        }
        ENDCG

        Pass
        {
            Stencil
            {
            Ref 1
            Comp Always
            }

            Cull Front
            ZWrite Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            float _OutlineSize;
            float4 _OutlineColor;
            float _ShowOutline;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : POSITION;
                float4 color : COLOR;
                float3 normal : NORMAL;
            };

            v2f vert(appdata v)
            {
                v.vertex.xyz *= (_OutlineSize)*_ShowOutline;
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.color = _OutlineColor;
                return o;
            }

            half4 frag(v2f i) : COLOR
            {
                return _OutlineColor;
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
