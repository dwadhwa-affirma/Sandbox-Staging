@isTest

private class KeyValuePairModelTest
{

static KeyValuePairModel instance = null;
static void SetUp(){
test.StartTest();
instance = new KeyValuePairModel();

}

static void TearDown(){
test.StopTest();
}

public static testmethod void Test_AllContructors(){
SetUp();
string localtext = '';
string localvalue = '';
KeyValuePairModel instance1 = new KeyValuePairModel(localtext, localvalue);

KeyValuePairModel instance2 = new KeyValuePairModel();

TearDown();
}
public static testmethod void Test_AllProperties(){
SetUp();

instance.Text = '';
System.Assert(instance.Text == '');


instance.Value = '';
System.Assert(instance.Value == '');

TearDown();
}
}