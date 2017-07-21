Shader "Custom/PuddleShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_NormalTex ("Normal Map", 2D) = "bump" {} 
		_PuddleTex ("Puddle", 2D) = "white" {}
		_Intensity ("Puddle Intensity", Range(0,1)) = 0.5
		_Wet ("Wetness", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf StandardSpecular fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _NormalTex;
		sampler2D _PuddleTex;

		struct Input {
			float2 uv_MainTex;
			float2 uv_PuddleTex;
		};

		half _Intensity;
		half _Wet;
		fixed4 _Color;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void surf (Input IN, inout SurfaceOutputStandardSpecular o) {

			float3 normalMap = UnpackNormal(tex2D(_NormalTex, IN.uv_MainTex));
			half4 puddleSpec = tex2D(_PuddleTex, IN.uv_PuddleTex);
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Normal = normalMap.rgb;
			o.Specular = puddleSpec.a * _Wet;
			o.Smoothness = _Intensity * puddleSpec.a;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
