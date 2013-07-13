﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.CSharp;
using System.CodeDom.Compiler;
using System.Reflection;

namespace Pes.Utility
{
    public static class ExpressionHelper
    {
        public static string Eval(string expression)
        {
            CSharpCodeProvider provider = new CSharpCodeProvider();
            CompilerParameters parameters = new CompilerParameters();

            parameters.ReferencedAssemblies.Add("system.dll");
            parameters.ReferencedAssemblies.Add("system.xml.dll");
            parameters.ReferencedAssemblies.Add("system.data.dll");
            parameters.ReferencedAssemblies.Add("system.windows.forms.dll");
            parameters.ReferencedAssemblies.Add("system.drawing.dll");

            parameters.CompilerOptions = "/t:library";
            parameters.GenerateInMemory = true;

            StringBuilder sourceBuilder = new StringBuilder("");
            sourceBuilder.Append("using System;\n");
            sourceBuilder.Append("using System.Xml;\n");
            sourceBuilder.Append("using System.Data;\n");
            sourceBuilder.Append("using System.Data.SqlClient;\n");
            sourceBuilder.Append("using System.Windows.Forms;\n");
            sourceBuilder.Append("using System.Drawing;\n");

            sourceBuilder.Append("namespace CSCodeEvaler{ \n");
            sourceBuilder.Append("public class CSCodeEvaler{ \n");
            sourceBuilder.Append("public object EvalCode(){\n");
            sourceBuilder.Append("return " + expression + "; \n");
            sourceBuilder.Append("} \n");
            sourceBuilder.Append("} \n");
            sourceBuilder.Append("}\n");

            try
            {
                CompilerResults results = provider.CompileAssemblyFromSource(parameters, sourceBuilder.ToString());
                if (results.Errors.Count > 0)
                {
                    return string.Empty;
                }

                System.Reflection.Assembly assembly = results.CompiledAssembly;
                object assemblyInstance = assembly.CreateInstance("CSCodeEvaler.CSCodeEvaler");

                Type assemblyInstanceType = assemblyInstance.GetType();
                MethodInfo info = assemblyInstanceType.GetMethod("EvalCode");

                object output = info.Invoke(assemblyInstance, null);
                return output.ToString();
            }
            catch
            {
                return string.Empty;
            }
        }
    }
}