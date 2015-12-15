cfndsl codedeploy helper methods
================================
## Requirements
- Master template includes parameter "EnvironmentName"

## Configuration
Copy codedeploy stack methods file to project (ext/codedeploy.rb)

Load file in master template:
```ruby
require_relative 'ext/codedeploy'
```

Add nested codedeploy stack to master template using method:

```ruby
if !((defined?codedeploy).nil?)
    nest_stack_codedeploy(codedeploy,"https://s3-#{source_region}.amazonaws.com/#{source_bucket}/cloudformation/#{cf_version}/codedeploy.json")
end
```

Create codedeploy template (codedeploy.rb):
```ruby
require_relative 'ext/codedeploy'
if !((defined?codedeploy).nil?)
  create_stack_codedeploy(codedeploy)
end
```

## YAML Format Example

```yaml
codedeploy:
  applications:
    -
      name: pineapple
      deployment_groups:
        -
          name: green
          deployment_config_name: CodeDeployDefault.OneAtATime
          type: asg
          asg_output_stack: WebStack
          asg_output_param: AutoScaleGroup
        -
          name: blue
          deployment_config_name: CodeDeployDefault.HalfAtATime
          type: tag
          tag_key: tier
          tag_value: worker
    -
      name: banana
      deployment_groups:
        -
          name: pink
          deployment_config_name: CodeDeployDefault.AllAtOnce
          type: asg
          asg_output_stack: WorkerStack
          asg_output_param: AutoScaleGroup
        -
          name: yellow
          deployment_config_name: CodeDeployDefault.OneAtATime
          type: tag
          tag_key: tier
          tag_value: admin
```
