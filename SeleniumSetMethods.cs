using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;

namespace FirstSelenium
{
    public class SeleniumSetMethods
    {
        

        //Enter Text 
        public static void EnterText(IWebDriver driver, string element, string value, string elementType)
        {
            if(elementType == "id")
                driver.FindElement(By.Id(element)).SendKeys(value);
            if (elementType == "name")
                driver.FindElement(By.Name(element)).SendKeys(value);
            if (elementType == "css-selector")
                driver.FindElement(By.CssSelector(element)).SendKeys(value);
        }

        //Click into a button, checkbox, option etc
        public static void Click(IWebDriver driver, string element, string elementType)
        {
            if (elementType == "id")
                driver.FindElement(By.Id(element)).Click();

            if (elementType == "name")
                driver.FindElement(By.Name(element)).Click();

            if (elementType == "css-selector")
                driver.FindElement(By.CssSelector(element)).Click();

        }

        //Selecting a drop down control
        public static void SelectDropdown(IWebDriver driver, string element, string value, string elementType)
        {

            if (elementType == "id")
                new SelectElement(driver.FindElement(By.Id(element))).SelectByText(value);
            if (elementType == "name")
                new SelectElement(driver.FindElement(By.Name(element))).SelectByText(value);
            if (elementType == "css-selector")
                new SelectElement(driver.FindElement(By.CssSelector(element))).SelectByText(value);
        }

        //Waiting for object to become visible
        public static void WaitForObject(IWebDriver driver, string element, string elementType)
        {

            if (elementType == "id")
            {
                WebDriverWait webDriverWait = new WebDriverWait(driver, TimeSpan.FromSeconds(10));
                WebDriverWait wait = webDriverWait;
                WebElement idElement = (WebElement)wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(element)));
            }
            if (elementType == "name")
            {
                WebDriverWait webDriverWait = new WebDriverWait(driver, TimeSpan.FromSeconds(10));
                WebDriverWait wait = webDriverWait;
                WebElement nameElement = (WebElement)wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Name(element)));
            }
            if (elementType == "css-selector")
            {
                WebDriverWait webDriverWait = new WebDriverWait(driver, TimeSpan.FromSeconds(10));
                WebDriverWait wait = webDriverWait;
                WebElement cssSelectorElement = (WebElement)wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.CssSelector(element)));
            }

        }

    }
}
