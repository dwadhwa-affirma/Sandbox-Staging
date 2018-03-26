<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Close_Date_for_Tasks</fullName>
        <field>Closed_Date__c</field>
        <formula>Today()</formula>
        <name>Set Close Date for Tasks</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Summary_to_Short_Description</fullName>
        <field>Summary__c</field>
        <formula>LEFT(Description,252) &amp; &apos;...&apos;</formula>
        <name>Set Summary to Short Description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Onboarding Complete</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>equals</operation>
            <value>Perform Onboarding 90 Day Follow Up Call</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Close Date for Tasks</fullName>
        <actions>
            <name>Set_Close_Date_for_Tasks</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Closed_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Summary for Tasks</fullName>
        <actions>
            <name>Set_Summary_to_Short_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Description &lt;&gt; null</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
