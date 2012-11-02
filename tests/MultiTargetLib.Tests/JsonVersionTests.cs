using System;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace MultiTargetLib.Tests
{
    [TestClass]
    public class JsonVersionTests
    {
        [TestMethod]
        public void Should_Have_Proper_Json_Version_Referenced()
        {
#if NET35
            var expected = "v2.0.50727";
#else
            var expected = "v4.0.30319";
#endif
            var actual = Calculator.NewtonsoftVersion;
            Assert.AreEqual(expected, actual);
        }

        [TestMethod]
        public void Should_Reference_Proper_Assemblies()
        {
#if NET35
            var expected = new Version(3, 5, 0, 0);
#else
            var expected = new Version(4, 0, 0, 0);
#endif
            var assemblies = Calculator.NewtonsoftReferences;
            var actual = assemblies.Single(x => "System.Core".Equals(x.Name));
            Assert.AreEqual(expected, actual.Version);
        }
    }
}
