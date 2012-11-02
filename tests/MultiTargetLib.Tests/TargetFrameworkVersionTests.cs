using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace MultiTargetLib.Tests
{
    [TestClass]
    public class TargetFrameworkVersionTests
    {
        [TestMethod]
        public void Should_Have_Framework_Version_45()
        {
            var version = Calculator.Version;
            Assert.AreEqual("NET45", version);
        }
    }
}
