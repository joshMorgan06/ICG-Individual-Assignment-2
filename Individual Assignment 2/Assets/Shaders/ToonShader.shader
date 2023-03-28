Shader "Custom/ToonShader"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_OutlineColor("OutlineColor", Color) = (0, 0, 0, 1)
		_OutlineSize("OutlineSize", Range(0.002, 5)) = 1
		[Toggle] _ShowOutline("Show Outline?", Float) = 1

		_MainTex("Albedo (RGB)", 2D) = "white" {}
		[Toggle] _ShowTexture("Show Texture?", Float) = 1
		_RampTex("Ramp Texture", 2D) = "white"{}
		[Toggle] _ShowDecal("Show Decal", Float) = 0
		_decalTex("Decal", 2D) = "white" {}

		_RimColor("Rim Color", Color) = (1, 1, 1, 1)
		_RimPower("Rim Power", Range(0.5, 15.0)) = 15.0
		[Toggle] _ShowRimLight("Show Rim Light?", Float) = 1
	}

	SubShader
	{
		Tags {"RenderType" = "Opaque"}
		LOD 200

		Stencil
		{
			Ref 1
			Comp Always
			Pass Replace
		}

		CGPROGRAM
		#pragma surface surf ToonRamp
		#pragma target 3.0

		float4 _Color;
		sampler2D _RampTex;
		sampler2D _MainTex;
		float _ShowTexture;
		sampler2D _decalTex;
		float _ShowDecal;
		float4 _RimColor;
		float _RimPower;
		float _ShowRimLight;

		float4 LightingToonRamp(SurfaceOutput s, fixed3 lightDir, fixed atten)
		{
			float diff = (dot(s.Normal, lightDir) * 0.5 + 0.5) * atten;
			float2 rh = diff;
			float3 ramp = tex2D(_RampTex, rh).rgb;

			float4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * (ramp);
			c.a = s.Alpha;
			return c;
		}

		struct Input
		{
			float2 uv_MainTex;
			float3 viewDir;
			float3 worldPos;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			fixed4 c = (tex2D(_MainTex, IN.uv_MainTex)) * _ShowTexture;
			fixed4 b = (tex2D(_decalTex, IN.uv_MainTex)) * _ShowDecal;
			o.Albedo = b.r > 0.5 ? b.rgb : c.rgb * _Color;
			half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
			o.Emission = (_RimColor.rgb * pow(rim, _RimPower)) * _ShowRimLight;
			o.Alpha = c.a;
		}

		ENDCG
		
		Tags
		{
			"Queue" = "Transparent"
		}
		LOD 200

		// Outline Pass
		Pass
		{
			Cull front

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
				float4 pos : SV_POSITION;
				float4 color : COLOR;
			};

			v2f vert(appdata v)
			{
				v.vertex.xyz *= _ShowOutline;
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);

				float3 norm = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal));
				float2 offset = TransformViewToProjection(norm.xy);

				o.pos.xy += offset * o.pos.z * _OutlineSize;
				o.color = _OutlineColor;
				return o;
			}

			fixed4 frag(v2f i) : SV_TARGET
			{
				return i.color;
			}

			ENDCG
		}
	}
	
	FallBack "Diffuse"
}
