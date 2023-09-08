using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support.UI;
using OpenQA.Selenium.Support;
using System;
using NUnit.Framework;


namespace FirstSelenium
{
    public class Program
    {

        //Create reference
        IWebDriver driver = new ChromeDriver();
        bool stringFound = false;


    static void Main()
        {

        }

        [SetUp]
        public void Initialize()
        {
            //Navigate to google
            driver.Navigate().GoToUrl("http://www.google.com");
            driver.Manage().Window.Maximize();
            Console.WriteLine("Opened URL");
        }


        [TearDown]
        public void CleanUp()
        {
            //Close driver
            driver.Quit();
            Console.WriteLine("Closed the browser");
        }
    



        [Test]
        public void ExecuteTest()
        {
            //Search
            SeleniumSetMethods.EnterText(driver, "APjFqb", "Cornerstone strategic fund", "id");
            //Created a Wait method instead of hard coding it into the test. We can now call it for every test
            SeleniumSetMethods.WaitForObject(driver, "btnK", "name");


            //Click
            SeleniumSetMethods.Click(driver, "btnK", "name");
            SeleniumSetMethods.Click(driver, "#rso > div:nth-child(1) > div > div > div > div > div > div > div > div.yuRUbf > div > a", "css-selector");
            SeleniumSetMethods.Click(driver, "#sidebar-wrapper > ul > li:nth-child(4) > a", "css-selector");

            //Scanning for the specific string with Xpath
            try
            {
                var elements = driver.FindElements(By.XPath("//div[@class='press-releases-holder']//p//a[contains(., 'Offeri')]"));
                if (elements.Count > 0)
                {
                    Assert.Fail("DANGER! Right Offerings found!");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("DANGER! Right Offerings found!" + ex.Message);
            }
        }
    }


      

}

