ACCOUT=
VPC_ID=
PUBLIC_SUBNET_1_ID=
PUBLIC_SUBNET_2_ID=
SECURITY_GROUP_ID=
#
#
#
TARGET_GROUP_WEBSERVER_ARN=$(aws elbv2 create-target-group
--name webserver
--protocol HTTP
--port 8080
--target-type ip
--ip-address-type ipv6
--vpc-id $VPC_ID
--health-check-path /health
[--protocol-version HTTP1]
[--health-check-protocol HTTP]
[--health-check-port traffic-port]
--query TargetGroups[0].TargetGroupArn
--output text)

TARGET_GROUP_APISERVER_ARN=$(aws elbv2 create-target-group
--name apiserver
--protocol HTTP
--port 9876
--target-type ip
--ip-address-type ipv6
--vpc-id $VPC_ID
--health-check-path /health
--query TargetGroups[0].TargetGroupArn
--output text)

TARGET_GROUP_FVSERVER_ARN=$(aws elbv2 create-target-group
--name fvserver
--protocol HTTP
--port 9878
--target-type ip
--ip-address-type ipv6
--vpc-id $VPC_ID
--health-check-path /health
--query TargetGroups[0].TargetGroupArn
--output text)

TARGET_GROUP_WSSERVER_ARN=$(aws elbv2 create-target-group
--name wsserver
--protocol HTTP
--port 9880
--target-type ip
--ip-address-type ipv6
--vpc-id $VPC_ID
--health-check-path /health
--query TargetGroups[0].TargetGroupArn
--output text)

TARGET_GROUP_CUBESERVER_ARN=$(aws elbv2 create-target-group
--name cubeserver
--protocol HTTP
--port 9882
--target-type ip
--ip-address-type ipv6
--vpc-id $VPC_ID
--health-check-path /health
--query TargetGroups[0].TargetGroupArn
--output text)

#
#
#
aws elbv2 register-targets
--target-group-arn TARGET_GROUP_WEBSERVER_ARN
--targets <value>

aws elbv2 register-targets
--target-group-arn TARGET_GROUP_APISERVER_ARN
--targets <value>

aws elbv2 register-targets
--target-group-arn TARGET_GROUP_FVSERVER_ARN
--targets <value>

aws elbv2 register-targets
--target-group-arn TARGET_GROUP_WSSERVER_ARN
--targets <value>

aws elbv2 register-targets
--target-group-arn TARGET_GROUP_CUBESERVER_ARN
--targets <value>

#
#
#
LOAD_BALANCER_ARN=$(aws elbv2 create-load-balancer
--name dev-alb
--type application
--subnets $PUBLIC_SUBNET_1_ID $PUBLIC_SUBNET_2_ID
--security-groups $SECURITY_GROUP_ID
--scheme internet-facing
--ip-address-type ipv6
--query LoadBalancers[0].LoadBalancerArn
--output text)

#
#
#
aws elbv2 create-listener
--load-balancer-arn $LOAD_BALANCER_ARN
--protocol HTTPS
--port 80
--default-actions XXXXX

aws elbv2 create-listener
--load-balancer-arn $LOAD_BALANCER_ARN
--protocol HTTPS
--port 443
--certificates $CERTIFICATE_ARN
--default-actions XXXXX


LISTENER_22443_ARN=$(aws elbv2 create-listener
--load-balancer-arn $LOAD_BALANCER_ARN
--protocol HTTPS
--port 22443
--certificates $CERTIFICATE_ARN
--default-actions XXXXX
--query Listeners[0].ListenerArn
--output text)

#
#
#
[
  {
    "Type": "forward"|"authenticate-oidc"|"authenticate-cognito"|"redirect"|"fixed-response",
    "TargetGroupArn": "string",
    "AuthenticateOidcConfig": {
      "Issuer": "string",
      "AuthorizationEndpoint": "string",
      "TokenEndpoint": "string",
      "UserInfoEndpoint": "string",
      "ClientId": "string",
      "ClientSecret": "string",
      "SessionCookieName": "string",
      "Scope": "string",
      "SessionTimeout": long,
      "AuthenticationRequestExtraParams": {"string": "string"
        ...},
      "OnUnauthenticatedRequest": "deny"|"allow"|"authenticate",
      "UseExistingClientSecret": true|false
    },
    "AuthenticateCognitoConfig": {
      "UserPoolArn": "string",
      "UserPoolClientId": "string",
      "UserPoolDomain": "string",
      "SessionCookieName": "string",
      "Scope": "string",
      "SessionTimeout": long,
      "AuthenticationRequestExtraParams": {"string": "string"
        ...},
      "OnUnauthenticatedRequest": "deny"|"allow"|"authenticate"
    },
    "Order": integer,
    "RedirectConfig": {
      "Protocol": "string",
      "Port": "string",
      "Host": "string",
      "Path": "string",
      "Query": "string",
      "StatusCode": "HTTP_301"|"HTTP_302"
    },
    "FixedResponseConfig": {
      "MessageBody": "string",
      "StatusCode": "string",
      "ContentType": "string"
    },
    "ForwardConfig": {
      "TargetGroups": [
        {
          "TargetGroupArn": "string",
          "Weight": integer
        }
        ...
      ],
      "TargetGroupStickinessConfig": {
        "Enabled": true|false,
        "DurationSeconds": integer
      }
    }
  }
  ...
]

#
#
#
aws elbv2 create-rule
--listener-arn $LISTENER_22443_ARN
--conditions <value>
--actions <value>
--priority <value>

aws elbv2 create-rule
--listener-arn $LISTENER_22443_ARN
--conditions <value>
--actions <value>
--priority <value>

aws elbv2 create-rule
--listener-arn $LISTENER_22443_ARN
--conditions <value>
--actions <value>
--priority <value>

