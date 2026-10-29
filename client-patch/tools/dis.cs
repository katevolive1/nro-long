using System;using System.Collections.Generic;using System.IO;using System.Text;using System.Text.RegularExpressions;using Iced.Intel;
public static class Dis{
 static Dictionary<long,string> names;
 static void Load(string scriptJson){
  if(names!=null)return; names=new Dictionary<long,string>();
  var txt=File.ReadAllText(scriptJson);
  foreach(Match m in new Regex("\"Address\":\\s*(\\d+),\\s*\"(Name|Value)\":\\s*\"((?:[^\"\\\\]|\\\\.)*)\"").Matches(txt)){
   long a=long.Parse(m.Groups[1].Value); string v=m.Groups[2].Value=="Value"?"\""+Regex.Unescape(m.Groups[3].Value)+"\"":m.Groups[3].Value;
   if(!names.ContainsKey(a))names[a]=v;}
 }
 // Dich nguoc khoang RVA [s,e) cua .text (offset file = RVA - 0x1800)
 public static string Run(string dll,string scriptJson,long s,long e){
  Load(scriptJson);
  var b=File.ReadAllBytes(dll); int off=(int)(s-0x1800); var code=new byte[e-s]; Array.Copy(b,off,code,0,code.Length);
  var dec=Iced.Intel.Decoder.Create(64,new ByteArrayCodeReader(code)); dec.IP=(ulong)s;
  var sb=new StringBuilder();
  while(dec.IP<(ulong)e){ var ins=dec.Decode(); string asm=ins.ToString();
   string note=""; long t=-1;
   if(ins.IsIPRelativeMemoryOperand) t=(long)ins.IPRelativeMemoryAddress;
   else if(ins.FlowControl==FlowControl.Call||ins.FlowControl==FlowControl.UnconditionalBranch||ins.FlowControl==FlowControl.ConditionalBranch) if(ins.Op0Kind==OpKind.NearBranch64) t=(long)ins.NearBranch64;
   string n; if(t>=0&&names.TryGetValue(t,out n)) note="   ; "+n;
   var hex=new StringBuilder(); for(int i=0;i<ins.Length;i++) hex.Append(code[(long)ins.IP-s+i].ToString("X2"));
   sb.AppendLine(string.Format("{0:X}  {1,-24} {2}{3}",ins.IP,hex,asm,note));}
  return sb.ToString();}}
