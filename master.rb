require_relative 'ext/codedeploy'

CloudFormation {

  # Template metadata
  AWSTemplateFormatVersion '2010-09-09'

  # Parameters
  Parameter("EnvironmentName"){ Type 'String' }

  Resource("WebStack") {
    Type 'AWS::CloudFormation::Stack'
    Property('TemplateURL', "https://s3-#{source_region}.amazonaws.com/#{source_bucket}/cloudformation/#{cf_version}/web.json" )
    Property('TimeoutInMinutes', 5)
    Property('Parameters',{
      EnvironmentName: Ref('EnvironmentName'),
    })
  }

  Resource("WorkerStack") {
    Type 'AWS::CloudFormation::Stack'
    Property('TemplateURL', "https://s3-#{source_region}.amazonaws.com/#{source_bucket}/cloudformation/#{cf_version}/worker.json" )
    Property('TimeoutInMinutes', 5)
    Property('Parameters',{
      EnvironmentName: Ref('EnvironmentName'),
    })
  }

  if !((defined?codedeploy).nil?)
    nest_stack_codedeploy(codedeploy,"https://s3-#{source_region}.amazonaws.com/#{source_bucket}/cloudformation/#{cf_version}/codedeploy.json")
  end
}
