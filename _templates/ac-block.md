### AC-{{ac_number}} — {{title}}‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍

> Scope: `docs/{{feature}}/userstories/us-{{story_number}}.md`

* __Type:__ {{type}}
* __Covers:__ FR-{{feature}}-{{fr_number}}
* __Screen:__ {{screen_ref}}
* __Error code:__ E-{{feature}}-{{error_number}}

```gherkin
Given {{given}}
When {{when}}
Then {{then}}
```

<!-- Biến thể — nhiều scenario cùng 1 business rule: gom dưới Rule: -->

### AC-{{ac_number}} — {{rule_title}}‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍

> Scope: `docs/{{feature}}/userstories/us-{{story_number}}.md`‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍

* __Type:__ business-rule
* __Covers:__ FR-{{feature}}-{{fr_number}} / BR-{{feature}}-{{br_number}}

```gherkin
Rule: {{rule_statement}}

  Scenario: {{scenario_title}}
    Given {{given}}
    When {{when}}
    Then {{then}}
```

<!-- Biến thể — cùng rule, nhiều bộ dữ liệu: Scenario Outline + Examples -->

### AC-{{ac_number}} — {{outline_title}}‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍

> Scope: `docs/{{feature}}/userstories/us-{{story_number}}.md`

* __Type:__ business-rule
* __Covers:__ FR-{{feature}}-{{fr_number}} / BR-{{feature}}-{{br_number}}‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍

```gherkin
Rule: {{rule_statement}}

  Scenario Outline: {{outline_title}}
    Given {{given_with_placeholder}}
    When {{when_with_placeholder}}
    Then {{then_with_placeholder}}

    Examples:
      | {{param_1}} | {{param_2}} | {{expected}} |
      | {{value_1a}} | {{value_2a}} | {{expected_a}} |
      | {{value_1b}} | {{value_2b}} | {{expected_b}} |
```


<!-- wm:deb1cafe78b51baaf650c76e2fceb009 -->
<sub>Tài liệu thuộc bộ AI4BA BA-Kit — bản quyền ai4ba.com</sub>
