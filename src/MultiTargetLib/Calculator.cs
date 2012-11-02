using System.Reflection;
using Newtonsoft.Json.Linq;

namespace MultiTargetLib
{
    public class Calculator
    {
#if NET35
        public static string Version { get { return "NET35"; } }
#elif NET40
        public static string Version { get { return "NET40"; } }
#elif NET45
        public static string Version { get { return "NET45"; } }
#endif

        public static string NewtonsoftVersion
        {
            get { return Assembly.GetAssembly(typeof (JToken)).ImageRuntimeVersion; }
        }

        public static AssemblyName[] NewtonsoftReferences
        {
            get { return Assembly.GetAssembly(typeof (JToken)).GetReferencedAssemblies(); }
        }
    }
}