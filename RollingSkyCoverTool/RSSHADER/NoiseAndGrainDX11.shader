Shader "Hidden/NoiseAndGrainDX11" {
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
				float2 texcoord4 : TEXCOORD4;
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
			float _DX11NoiseTime;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.vertex.y;
                o.texcoord.y = tmp0.x ? tmp0.y : v.vertex.y;
                tmp0.xy = v.texcoord1.xy * _NoiseTilingPerChannel.zz;
                o.texcoord2.xy = tmp0.xy * _NoiseTex_TexelSize.xy + v.texcoord.xy;
                o.texcoord.x = v.vertex.x;
                tmp0 = v.texcoord1.xyxy * _NoiseTilingPerChannel.xxyy;
                o.texcoord1 = tmp0 * _NoiseTex_TexelSize + v.texcoord.xyxy;
                o.texcoord4.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xy = inp.texcoord.xy + inp.texcoord4.xy;
                tmp0.xy = tmp0.xy * _MainTex_TexelSize.zw;
                tmp0.xy = asint(tmp0.xy);
                tmp0.z = asint(_DX11NoiseTime);
                tmp0.yz = float2(int2(tmp0.zy) << int2(16, 8));
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = float1(int1(tmp0.x) << 13);
                //unsupported_xor;
                tmp0.xz = tmp0.xx + int2(57, 113);
                tmp0.w = tmp0.y * tmp0.y;
                tmp0.w = tmp0.w * 15731 + 789221;
                tmp0.y = tmp0.y * tmp0.w + 1376312589;
                tmp0.y = uint1(tmp0.y) & uint1(NaN);
                tmp0.y = floor(tmp0.y);
                tmp1.x = tmp0.y * 0.0;
                tmp0.yw = float2(int2(tmp0.xz) << int2(13, 13));
                //unsupported_xor;
                tmp0.zw = tmp0.xy * tmp0.xy;
                tmp0.zw = tmp0.zw * int2(15731, 15731) + int2(789221, 789221);
                tmp0.xy = tmp0.xy * tmp0.zw + int2(1376312589, 1376312589);
                tmp0.xy = uint2(tmp0.xy) & uint2(float2(NaN, NaN));
                tmp0.xy = floor(tmp0.xy);
                tmp1.yz = tmp0.xy * float2(0.0, 0.0);
                tmp0.xyz = tmp1.xyz - float3(0.5, 0.5, 0.5);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = saturate(tmp1);
                tmp0.w = dot(tmp1.xyz, float3(0.22, 0.707, 0.071));
                tmp0.w = tmp0.w - _MidGrey.x;
                tmp2.xy = saturate(tmp0.ww * _MidGrey.yz);
                tmp0.w = dot(_NoiseAmount.xy, tmp2.xy);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = tmp0.w + _NoiseAmount.x;
                tmp2.xyz = tmp0.www * _NoisePerChannel;
                tmp0.xyz = saturate(tmp2.xyz * tmp0.xyz + float3(0.5, 0.5, 0.5));
                tmp2.xyz = float3(1.0, 1.0, 1.0) - tmp0.xyz;
                tmp3.xyz = tmp1.xyz - float3(0.5, 0.5, 0.5);
                tmp3.xyz = -tmp3.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp2.xyz = -tmp3.xyz * tmp2.xyz + float3(1.0, 1.0, 1.0);
                tmp3.xyz = tmp1.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp3.xyz;
                tmp1.xyz = tmp1.xyz >= float3(0.5, 0.5, 0.5);
                o.sv_target.w = tmp1.w;
                tmp0.xyz = tmp1.xyz ? float3(0.0, 0.0, 0.0) : tmp0.xyz;
                tmp1.xyz = tmp1.xyz ? 1.0 : 0.0;
                o.sv_target.xyz = tmp1.xyz * tmp2.xyz + tmp0.xyz;
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
				float2 texcoord4 : TEXCOORD4;
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
			float3 _NoiseAmount;
			float3 _MidGrey;
			float _DX11NoiseTime;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.vertex.y;
                o.texcoord.y = tmp0.x ? tmp0.y : v.vertex.y;
                tmp0.xy = v.texcoord1.xy * _NoiseTilingPerChannel.zz;
                o.texcoord2.xy = tmp0.xy * _NoiseTex_TexelSize.xy + v.texcoord.xy;
                o.texcoord.x = v.vertex.x;
                tmp0 = v.texcoord1.xyxy * _NoiseTilingPerChannel.xxyy;
                o.texcoord1 = tmp0 * _NoiseTex_TexelSize + v.texcoord.xyxy;
                o.texcoord4.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = inp.texcoord.xy + inp.texcoord4.xy;
                tmp0.xy = tmp0.xy * _MainTex_TexelSize.zw;
                tmp0.xy = asint(tmp0.xy);
                tmp0.z = asint(_DX11NoiseTime);
                tmp0.yz = float2(int2(tmp0.zy) << int2(16, 8));
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = float1(int1(tmp0.x) << 13);
                //unsupported_xor;
                tmp0.y = tmp0.x * tmp0.x;
                tmp0.y = tmp0.y * 15731 + 789221;
                tmp0.x = tmp0.x * tmp0.y + 1376312589;
                tmp0.x = uint1(tmp0.x) & uint1(NaN);
                tmp0.x = floor(tmp0.x);
                tmp0.x = tmp0.x * 0.0 + -0.5;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = saturate(tmp1);
                tmp0.y = dot(tmp1.xyz, float3(0.22, 0.707, 0.071));
                tmp0.y = tmp0.y - _MidGrey.x;
                tmp0.yz = saturate(tmp0.yy * _MidGrey.yz);
                tmp0.y = dot(_NoiseAmount.xy, tmp0.xy);
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.y = tmp0.y + _NoiseAmount.x;
                tmp0.x = saturate(tmp0.y * tmp0.x + 0.5);
                tmp0.y = 1.0 - tmp0.x;
                tmp2.xyz = tmp1.xyz - float3(0.5, 0.5, 0.5);
                tmp2.xyz = -tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp0.yzw = -tmp2.xyz * tmp0.yyy + float3(1.0, 1.0, 1.0);
                tmp2.xyz = tmp1.xyz + tmp1.xyz;
                tmp2.xyz = tmp0.xxx * tmp2.xyz;
                tmp1.xyz = tmp1.xyz >= float3(0.5, 0.5, 0.5);
                o.sv_target.w = tmp1.w;
                tmp2.xyz = tmp1.xyz ? float3(0.0, 0.0, 0.0) : tmp2.xyz;
                tmp1.xyz = tmp1.xyz ? 1.0 : 0.0;
                o.sv_target.xyz = tmp1.xyz * tmp0.yzw + tmp2.xyz;
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
				float2 texcoord4 : TEXCOORD4;
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
			float _DX11NoiseTime;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.vertex.y;
                o.texcoord.y = tmp0.x ? tmp0.y : v.vertex.y;
                tmp0.xy = v.texcoord1.xy * _NoiseTilingPerChannel.zz;
                o.texcoord2.xy = tmp0.xy * _NoiseTex_TexelSize.xy + v.texcoord.xy;
                o.texcoord.x = v.vertex.x;
                tmp0 = v.texcoord1.xyxy * _NoiseTilingPerChannel.xxyy;
                o.texcoord1 = tmp0 * _NoiseTex_TexelSize + v.texcoord.xyxy;
                o.texcoord4.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = inp.texcoord.xy + inp.texcoord4.xy;
                tmp0.xy = tmp0.xy * _MainTex_TexelSize.zw;
                tmp0.xy = asint(tmp0.xy);
                tmp0.z = asint(_DX11NoiseTime);
                tmp0.yz = float2(int2(tmp0.zy) << int2(16, 8));
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = float1(int1(tmp0.x) << 13);
                //unsupported_xor;
                tmp0.xz = tmp0.xx + int2(57, 113);
                tmp0.w = tmp0.y * tmp0.y;
                tmp0.w = tmp0.w * 15731 + 789221;
                tmp0.y = tmp0.y * tmp0.w + 1376312589;
                tmp0.y = uint1(tmp0.y) & uint1(NaN);
                tmp0.y = floor(tmp0.y);
                tmp1.x = tmp0.y * 0.0;
                tmp0.yw = float2(int2(tmp0.xz) << int2(13, 13));
                //unsupported_xor;
                tmp0.zw = tmp0.xy * tmp0.xy;
                tmp0.zw = tmp0.zw * int2(15731, 15731) + int2(789221, 789221);
                tmp0.xy = tmp0.xy * tmp0.zw + int2(1376312589, 1376312589);
                tmp0.xy = uint2(tmp0.xy) & uint2(float2(NaN, NaN));
                tmp0.xy = floor(tmp0.xy);
                tmp1.yz = tmp0.xy * float2(0.0, 0.0);
                tmp0.xyz = tmp1.xyz - float3(0.5, 0.5, 0.5);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = saturate(tmp1);
                tmp0.w = dot(tmp1.xyz, float3(0.22, 0.707, 0.071));
                o.sv_target.w = tmp1.w;
                tmp0.w = tmp0.w - _MidGrey.x;
                tmp1.xy = saturate(tmp0.ww * _MidGrey.yz);
                tmp0.w = dot(_NoiseAmount.xy, tmp1.xy);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = tmp0.w + _NoiseAmount.x;
                tmp1.xyz = tmp0.www * _NoisePerChannel;
                o.sv_target.xyz = saturate(tmp1.xyz * tmp0.xyz + float3(0.5, 0.5, 0.5));
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
				float2 texcoord4 : TEXCOORD4;
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
			float3 _NoiseAmount;
			float3 _MidGrey;
			float _DX11NoiseTime;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.vertex.y;
                o.texcoord.y = tmp0.x ? tmp0.y : v.vertex.y;
                tmp0.xy = v.texcoord1.xy * _NoiseTilingPerChannel.zz;
                o.texcoord2.xy = tmp0.xy * _NoiseTex_TexelSize.xy + v.texcoord.xy;
                o.texcoord.x = v.vertex.x;
                tmp0 = v.texcoord1.xyxy * _NoiseTilingPerChannel.xxyy;
                o.texcoord1 = tmp0 * _NoiseTex_TexelSize + v.texcoord.xyxy;
                o.texcoord4.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = inp.texcoord.xy + inp.texcoord4.xy;
                tmp0.xy = tmp0.xy * _MainTex_TexelSize.zw;
                tmp0.xy = asint(tmp0.xy);
                tmp0.z = asint(_DX11NoiseTime);
                tmp0.yz = float2(int2(tmp0.zy) << int2(16, 8));
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = float1(int1(tmp0.x) << 13);
                //unsupported_xor;
                tmp0.y = tmp0.x * tmp0.x;
                tmp0.y = tmp0.y * 15731 + 789221;
                tmp0.x = tmp0.x * tmp0.y + 1376312589;
                tmp0.x = uint1(tmp0.x) & uint1(NaN);
                tmp0.x = floor(tmp0.x);
                tmp0.x = tmp0.x * 0.0 + -0.5;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = saturate(tmp1);
                tmp0.y = dot(tmp1.xyz, float3(0.22, 0.707, 0.071));
                o.sv_target.w = tmp1.w;
                tmp0.y = tmp0.y - _MidGrey.x;
                tmp0.yz = saturate(tmp0.yy * _MidGrey.yz);
                tmp0.y = dot(_NoiseAmount.xy, tmp0.xy);
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.y = tmp0.y + _NoiseAmount.x;
                tmp0.x = tmp0.y * tmp0.x + 0.5;
                o.sv_target.xyz = saturate(tmp0.xxx);
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
				float2 texcoord4 : TEXCOORD4;
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
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.vertex.y;
                o.texcoord.y = tmp0.x ? tmp0.y : v.vertex.y;
                tmp0.xy = v.texcoord1.xy * _NoiseTilingPerChannel.zz;
                o.texcoord2.xy = tmp0.xy * _NoiseTex_TexelSize.xy + v.texcoord.xy;
                o.texcoord.x = v.vertex.x;
                tmp0 = v.texcoord1.xyxy * _NoiseTilingPerChannel.xxyy;
                o.texcoord1 = tmp0 * _NoiseTex_TexelSize + v.texcoord.xyxy;
                o.texcoord4.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xyz = tex2D(_NoiseTex, inp.texcoord.xy);
                tmp0.xyz = saturate(tmp0.xyz);
                tmp1.xyz = float3(1.0, 1.0, 1.0) - tmp0.xyz;
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2 = saturate(tmp2);
                tmp3.xyz = tmp2.xyz - float3(0.5, 0.5, 0.5);
                tmp3.xyz = -tmp3.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = -tmp3.xyz * tmp1.xyz + float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2.xyz = tmp2.xyz >= float3(0.5, 0.5, 0.5);
                o.sv_target.w = tmp2.w;
                tmp0.xyz = tmp2.xyz ? float3(0.0, 0.0, 0.0) : tmp0.xyz;
                tmp2.xyz = tmp2.xyz ? 1.0 : 0.0;
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp2.xyz * tmp1.xyz + tmp0.xyz;
                return o;
			}
			ENDCG
		}
	}
}