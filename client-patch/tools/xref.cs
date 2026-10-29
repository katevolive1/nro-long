using System;using System.Collections.Generic;using System.IO;using System.Text.RegularExpressions;
public static class Xref{
 // Tim lenh RIP-relative tro toi cac RVA target trong .text, tra ve "rva<TAB>ten ham"
 public static string[] Find(string dll,string scriptJson,long[] targets){
  var b=File.ReadAllBytes(dll);
  var A=new List<long>();var N=new List<string>();
  var txt=File.ReadAllText(scriptJson);
  int s=txt.IndexOf("\"ScriptMethod\"");int e=txt.IndexOf("\"ScriptString\"");if(e<0)e=txt.Length;
  foreach(Match m in new Regex("\"Address\":\\s*(\\d+),\\s*\"Name\":\\s*\"([^\"]+)\"").Matches(txt.Substring(s,e-s))){A.Add(long.Parse(m.Groups[1].Value));N.Add(m.Groups[2].Value);}
  var idx=new int[A.Count];for(int i=0;i<idx.Length;i++)idx[i]=i;Array.Sort(A.ToArray(),idx);A.Sort();
  var ts=new HashSet<long>(targets);var res=new List<string>();
  for(int i=0x400;i<b.Length-4;i++){long rva=i+0x1800;long t=rva+4+BitConverter.ToInt32(b,i);
   if(ts.Contains(t)){int k=A.BinarySearch(rva);if(k<0)k=~k-1;string n=k>=0&&rva-A[k]<0x8000?N[idx[k]]:"?";res.Add(string.Format("0x{0:X}\t0x{1:X}\t{2}",t,rva,n));}}
  return res.ToArray();}
 // Liet ke lenh call (E8) va chuoi duoc nap trong khoang [s,e)
 public static string[] Calls(string dll,string scriptJson,string strJson,long s,long e){
  var b=File.ReadAllBytes(dll);var M=new Dictionary<long,string>();
  var txt=File.ReadAllText(scriptJson);int a=txt.IndexOf("\"ScriptMethod\"");int z=txt.IndexOf("\"ScriptString\"");if(z<0)z=txt.Length;
  foreach(Match m in new Regex("\"Address\":\\s*(\\d+),\\s*\"Name\":\\s*\"([^\"]+)\"").Matches(txt.Substring(a,z-a))){long k=long.Parse(m.Groups[1].Value);if(!M.ContainsKey(k))M[k]=m.Groups[2].Value;}
  var S=new Dictionary<long,string>();
  foreach(Match m in new Regex("\"value\":\\s*\"((?:[^\"\\\\]|\\\\.)*)\",\\s*\"address\":\\s*\"0x([0-9A-F]+)\"").Matches(File.ReadAllText(strJson)))S[Convert.ToInt64(m.Groups[2].Value,16)]=Regex.Unescape(m.Groups[1].Value);
  var res=new List<string>();
  for(long rva=s;rva<e;rva++){int i=(int)(rva-0x1800);
   if(b[i]==0xE8){long t=rva+5+BitConverter.ToInt32(b,i+1);string n;if(M.TryGetValue(t,out n))res.Add(string.Format("0x{0:X} call {1}",rva,n));}
   long t2=rva+4+BitConverter.ToInt32(b,i);string sv;if(S.TryGetValue(t2,out sv))res.Add(string.Format("0x{0:X} str \"{1}\"",rva,sv));}
  return res.ToArray();}}
