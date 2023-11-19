// Upgrade NOTE: replaced 'glstate_matrix_mvp' with 'UNITY_MATRIX_MVP'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/NoiseAndGrain" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_NoiseTex ("Noise (RGB)", 2D) = "white" {}
	}
	SubShader {
		Pass {
			ZTest Always
			ZWrite Off
			Cull Off
			Fog {
				Mode Off
			}
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _NoiseTex_TexelSize;
			float4 _MainTex_TexelSize;
			float3 _NoiseTilingPerChannel;
			// $Globals ConstantBuffers for Fragment Shader
			float3 _NoisePerChannel;
			float3 _NoiseAmount;
			float3 _MidGrey;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _NoiseTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                o.position = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.vertex.xy;
				o.texcoord1 = (v.texcoord.xyxy + ((v.texcoord1.xyxy * _NoiseTilingPerChannel.xxyy) * _NoiseTex_TexelSize.xyxy));
				o.texcoord2 = (v.texcoord.xy + ((v.texcoord1.xy * _NoiseTilingPerChannel.zz) * _NoiseTex_TexelSize.xy));
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float3 m_1;
				float4 color_2;
				fixed4 tmpvar_3;
				tmpvar_3 = tex2D (_MainTex, inp.texcoord);
				color_2 = tmpvar_3;
				half3 c_4;
				c_4 = color_2.xyz;
				half tmpvar_5;
				tmpvar_5 = dot (c_4, unity_ColorSpaceLuminance.xyz);
				fixed4 tmpvar_6;
				tmpvar_6 = tex2D (_NoiseTex, inp.texcoord1.xy);
				m_1 = (tmpvar_6 * float4(1.0, 0.0, 0.0, 0.0)).xyz;
				fixed4 tmpvar_7;
				tmpvar_7 = tex2D (_NoiseTex, inp.texcoord1.zw);
				m_1 = (m_1 + (tmpvar_7 * float4(0.0, 1.0, 0.0, 0.0)).xyz);
				fixed4 tmpvar_8;
				tmpvar_8 = tex2D (_NoiseTex, inp.texcoord2);
				m_1 = (m_1 + (tmpvar_8 * float4(0.0, 0.0, 1.0, 0.0)).xyz);
				float3 tmpvar_9;
				tmpvar_9 = clamp (lerp (float3(0.5, 0.5, 0.5), m_1, (_NoisePerChannel * (
				(_NoiseAmount.x + max (0.0, dot (_NoiseAmount.zy, clamp (
					(((tmpvar_5 - _MidGrey.x)) * _MidGrey.yz)
				, 0.0, 1.0))))
				))), 0.0, 1.0);
				m_1 = tmpvar_9;
				float3 tmpvar_10;
				tmpvar_10 = clamp (color_2.xyz, 0.0, 1.0);
				float3 tmpvar_11;
				tmpvar_11 = float3( (tmpvar_10, float3(0.5, 0.5, 0.5)));
				float4 tmpvar_12;
				tmpvar_12.xyz = ((tmpvar_11 * (float3(1.0, 1.0, 1.0) - 
				((float3(1.0, 1.0, 1.0) - (2.0 * (tmpvar_10 - 0.5))) * (1.0 - tmpvar_9))
				)) + ((
				(1.0 - tmpvar_11)
				* 
				(2.0 * tmpvar_10)
				) * tmpvar_9));
				tmpvar_12.w = color_2.w;
				o.sv_target = tmpvar_12;
                return o;
			}
			ENDCG
		}
		Pass {
			ZTest Always
			ZWrite Off
			Cull Off
			Fog {
				Mode Off
			}
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _NoiseTex_TexelSize;
			float4 _MainTex_TexelSize;
			float3 _NoiseTilingPerChannel;
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _NoiseTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                o.position = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.vertex.xy;
				o.texcoord1 = (v.texcoord.xyxy + ((v.texcoord1.xyxy * _NoiseTilingPerChannel.xxyy) * _NoiseTex_TexelSize.xyxy));
				o.texcoord2 = (v.texcoord.xy + ((v.texcoord1.xy * _NoiseTilingPerChannel.zz) * _NoiseTex_TexelSize.xy));
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 m_1;
				float4 color_2;
				fixed4 tmpvar_3;
				tmpvar_3 = tex2D (_MainTex, inp.texcoord);
				color_2 = tmpvar_3;
				fixed4 tmpvar_4;
				tmpvar_4 = tex2D (_NoiseTex, inp.texcoord);
				m_1 = tmpvar_4;
				float3 tmpvar_5;
				tmpvar_5 = clamp (color_2.xyz, 0.0, 1.0);
				float3 tmpvar_6;
				tmpvar_6 = float3( (tmpvar_5, float3(0.5, 0.5, 0.5)));
				float4 tmpvar_7;
				tmpvar_7.xyz = ((tmpvar_6 * (float3(1.0, 1.0, 1.0) - 
				((float3(1.0, 1.0, 1.0) - (2.0 * (tmpvar_5 - 0.5))) * (1.0 - m_1.xyz))
				)) + ((
				(1.0 - tmpvar_6)
				* 
				(2.0 * tmpvar_5)
				) * m_1.xyz));
				tmpvar_7.w = color_2.w;
				o.sv_target = tmpvar_7;
                return o;
			}
			ENDCG
		}
		Pass {
			ZTest Always
			ZWrite Off
			Cull Off
			Fog {
				Mode Off
			}
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD2;
				float4 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _NoiseTex_TexelSize;
			float4 _MainTex_TexelSize;
			float3 _NoiseTilingPerChannel;
			// $Globals ConstantBuffers for Fragment Shader
			float3 _NoisePerChannel;
			float3 _NoiseAmount;
			float3 _MidGrey;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _NoiseTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                o.position = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.vertex.xy;
				o.texcoord1 = (v.texcoord.xyxy + ((v.texcoord1.xyxy * _NoiseTilingPerChannel.xxyy) * _NoiseTex_TexelSize.xyxy));
				o.texcoord2 = (v.texcoord.xy + ((v.texcoord1.xy * _NoiseTilingPerChannel.zz) * _NoiseTex_TexelSize.xy));
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float3 m_1;
				float4 color_2;
				fixed4 tmpvar_3;
				tmpvar_3 = tex2D (_MainTex, inp.texcoord);
				color_2 = tmpvar_3;
				half3 c_4;
				c_4 = color_2.xyz;
				half tmpvar_5;
				tmpvar_5 = dot (c_4, unity_ColorSpaceLuminance.xyz);
				fixed4 tmpvar_6;
				tmpvar_6 = tex2D (_NoiseTex, inp.texcoord1.xy);
				m_1 = (tmpvar_6 * float4(1.0, 0.0, 0.0, 0.0)).xyz;
				fixed4 tmpvar_7;
				tmpvar_7 = tex2D (_NoiseTex, inp.texcoord1.zw);
				m_1 = (m_1 + (tmpvar_7 * float4(0.0, 1.0, 0.0, 0.0)).xyz);
				fixed4 tmpvar_8;
				tmpvar_8 = tex2D (_NoiseTex, inp.texcoord2);
				m_1 = (m_1 + (tmpvar_8 * float4(0.0, 0.0, 1.0, 0.0)).xyz);
				float3 tmpvar_9;
				tmpvar_9 = clamp (lerp (float3(0.5, 0.5, 0.5), m_1, (_NoisePerChannel * (
				(_NoiseAmount.x + max (0.0, dot (_NoiseAmount.zy, clamp (
					(((tmpvar_5 - _MidGrey.x)) * _MidGrey.yz)
				, 0.0, 1.0))))
				))), 0.0, 1.0);
				m_1 = tmpvar_9;
				float4 tmpvar_10;
				tmpvar_10.xyz = tmpvar_9;
				tmpvar_10.w = color_2.w;
				o.sv_target = tmpvar_10;
                return o;
			}
			ENDCG
		}
	}
}