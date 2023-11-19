// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'glstate_matrix_mvp' with 'UNITY_MATRIX_MVP'

Shader "Mobile/Particles/OLD - Additive Culled" {
	Properties {
		_MainTex ("Particle Texture", 2D) = "white" {}
		_Color ("Tint Color", Vector) = (0.5,0.5,0.5,0.5)
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend SrcAlpha One, SrcAlpha One
			ColorMask RGB
			ZWrite Off
			Fog {
				Mode Linear
			}
			GpuProgramID 8766
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 color : COLOR0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float4 position : SV_POSITION0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                fixed4 tmpvar_1;
				half4 tmpvar_2;
				tmpvar_2 = clamp (v.color, 0.0, 1.0);
				tmpvar_1 = tmpvar_2;
				float4 tmpvar_3;
				tmpvar_3.w = 1.0;
				tmpvar_3.xyz = v.vertex.xyz;
				o.color = tmpvar_1;
				float2 tmpvar_4;
				tmpvar_4 = (v.texcoord.xy * _MainTex_ST.xy);
				o.texcoord = (tmpvar_4 + _MainTex_ST.zw);
				o.texcoord1 = (tmpvar_4 + _MainTex_ST.zw);
				o.position = UnityObjectToClipPos(tmpvar_3);
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                fixed4 col_1;
				col_1 = (_Color * inp.color);
				col_1 = (tex2D (_MainTex, inp.texcoord1) * col_1);
				col_1 = (col_1 * 2.0);
				if ((col_1.w <= 0.01)) {
				discard;
				};
				o.sv_target = col_1;
                return o;
			}
			ENDCG
		}
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend SrcAlpha One, SrcAlpha One
			ColorMask RGB
			ZWrite Off
			Fog {
				Mode Linear
			}
			GpuProgramID 91354
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 color : COLOR0;
				float2 texcoord : TEXCOORD0;
				float4 position : SV_POSITION0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                fixed4 tmpvar_1;
				half4 tmpvar_2;
				tmpvar_2 = clamp (v.color, 0.0, 1.0);
				tmpvar_1 = tmpvar_2;
				float4 tmpvar_3;
				tmpvar_3.w = 1.0;
				tmpvar_3.xyz = v.vertex.xyz;
				o.color = tmpvar_1;
				o.texcoord = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
				o.position = UnityObjectToClipPos(tmpvar_3);
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                fixed4 col_1;
				col_1 = (tex2D(_MainTex, inp.texcoord) * inp.color);
				if ((col_1.w <= 0.01)) {
				discard;
				};
				o.sv_target = col_1;
                return o;
			}
			ENDCG
		}
	}
}