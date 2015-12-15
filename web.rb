CloudFormation {

  # Template metadata
  AWSTemplateFormatVersion '2010-09-09'

  # Parameters
  Parameter("EnvironmentName"){ Type 'String' }

  LaunchConfiguration("LaunchConfig") {
    ImageId 'ami-48d38c2b'
    InstanceType 't2.micro'
  }

  Resource("ElasticLoadBalancer") {
    Type 'AWS::ElasticLoadBalancing::LoadBalancer'
    Property('Listeners', [ { 'LoadBalancerPort' => '80', 'InstancePort' => '80', 'Protocol' => 'HTTP' } ] )
    Property('LoadBalancerName',FnJoin('', [ Ref('EnvironmentName'), '-web' ]))
    Property('AvailabilityZones', [
      FnSelect('0',FnGetAZs(Ref('AWS::Region'))),
      FnSelect('1',FnGetAZs(Ref('AWS::Region')))
    ])
  }

  AutoScalingGroup("AutoScaleGroup") {
    AvailabilityZones [
      FnSelect('0',FnGetAZs(Ref('AWS::Region'))),
      FnSelect('1',FnGetAZs(Ref('AWS::Region')))
    ]
    LaunchConfigurationName Ref('LaunchConfig')
    LoadBalancerNames [ Ref('ElasticLoadBalancer') ]
    MinSize "1"
    MaxSize "1"
  }

  Output("AutoScaleGroup") {
    Value(Ref('AutoScaleGroup'))
  }
}
