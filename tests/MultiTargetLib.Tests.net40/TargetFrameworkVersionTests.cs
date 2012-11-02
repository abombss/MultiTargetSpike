using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace MultiTargetLib.Tests
{
    [TestClass]
    public class TargetFrameworkVersionTests
    {
        [TestMethod]
        public void Should_Have_Framework_Version_40()
        {
            var version = Calculator.Version;
            Assert.AreEqual("NET40", version);
        }
    }
}
