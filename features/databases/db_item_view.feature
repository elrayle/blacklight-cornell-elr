# encoding: UTF-8
Feature: Databases List 
  In order to get information about a featured databases 
  As a user
  I want to see the list of the digital collections

  @databases
  Scenario: View a list of databases
  	Given I go to literal databases
  	Then I should see the label 'Search top databases'

  @mla
  @databases
  Scenario: Make sure list contains known database 
  	Given I go to literal databases
  	Then I should see the label 'General Interest and Reference Biographies'

  @mla
  @databases
  Scenario: Make sure list contains known collection 
  	Given I go to literal databases
        And I fill in the search box with 'MLA'
        And I press 'search'
  	Then I should see the label 'MLA'


