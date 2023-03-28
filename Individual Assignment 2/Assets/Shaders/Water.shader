Shader "Custom/Water"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _FoamTex("Foam Texture", 2D) = "white" {}
        _RampTex("Ramp Texture", 2D) = "white"{}
        _AddRampTex("AddRamp Texture", 2D) = "white"{}
        _Tint("Colour Tint", Color) = (1,1,1,1)
        _Freq("Frequency", Range(0, 5)) = 3
        _Speed("Speed", Range(0, 100)) = 10
        _Amp("Amplitude", Range(0, 1)) = 0.5
        _ScrollX("Scroll X", Range(-5, 5)) = 1
        _ScrollY("Scroll Y", Range(-5, 5)) = 1
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf ToonRamp vertex:vert

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_FoamTex;
            float3 vertColor;
        };

        sampler2D _MainTex;
        sampler2D _FoamTex;
        sampler2D _RampTex;
        sampler2D _AddRampTex;
        float4 _Tint;
        float _Freq;
        float _Speed;
        float _Amp;
        float _ScrollX;
        float _ScrollY;

        struct appdata
        {
            float4 vertex : POSITION;
            float3 normal : NORMAL;
            float4 texcoord : TEXCOORD0;
            float4 texcoord1 : TEXCOORD01;
            float4 texcoord2 : TEXCOORD02;
        };

        float4 LightingToonRamp(SurfaceOutput s, fixed3 lightDir, fixed atten)
        {
            float diff = (dot(s.Normal, lightDir) * 0.5 + 0.5) * atten;
            float2 rh = diff;
            float3 ramp = tex2D(_RampTex, rh).rgb;
            float3 addRamp = tex2D(_AddRampTex, rh).rgb;

            float4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * (ramp / addRamp);
            c.a = s.Alpha;
            return c;
        }

        void vert(inout appdata v, out Input o) 
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);
            float t = _Time * _Speed;
            float waveHeight = sin(t + v.vertex.x * _Freq) * _Amp +
                sin(t * 2 + v.vertex.z * _Freq * 2) * _Amp;
            v.vertex.y = v.vertex.y + waveHeight;
            v.normal = normalize(float3(v.normal.x + waveHeight, v.normal.y, v.normal.z + waveHeight));
            o.vertColor = waveHeight + 2;
        }

        void surf(Input IN, inout SurfaceOutput o) 
        {
            _ScrollX *= _Time;
            _ScrollY *= _Time;
            float3 water = (tex2D(_MainTex, IN.uv_MainTex + float2(_ScrollX, _ScrollY))).rgb;
            float3 foam = (tex2D(_FoamTex, IN.uv_MainTex + float2(_ScrollX / 2.0, _ScrollY / 2.0))).rgb;
            float3 c = (water + foam) / 2.0;;
            o.Albedo = c * IN.vertColor.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
