@isTest
public class PostInstallTest {
@isTest
static void testInstallScript() {
  postInstallScript postinstall = new postInstallScript();
    Test.testInstall(postinstall, null);
    Test.testInstall(postinstall, new Version(1,0), true);
  }
}