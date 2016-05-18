require_relative 'ext/codedeploy'
if !((defined?codedeploy).nil?)
  create_stack_codedeploy(codedeploy,application_name,cf_version)
end
