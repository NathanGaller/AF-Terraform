package test

import (
	"fmt"
	"testing"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/eks"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestEksCluster(t *testing.T) {

	terraformOptions := &terraform.Options{
		TerraformDir: "./../",
		Vars: map[string]interface{}{
			"account_id":   "052911266688",
			"user_group":   "CyberCumulus",
			"username":     "nathan.galler@smoothstack.com",
			"user_arn":     "arn:aws:iam::052911266688:user/nathan.galler@smoothstack.com",
			"aws_region":   "us-west-2",
			"cluster_name": "ng-eks",
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	awsRegion := terraform.Output(t, terraformOptions, "region")
	clusterName := terraform.Output(t, terraformOptions, "cluster_name")

	sess, err := session.NewSession(&aws.Config{
		Region: aws.String(awsRegion),
	})

	if err != nil {
		t.Fatalf("Failed to create AWS session: %v", err)
	}

	eksClient := eks.New(sess)

	clusterOutput, err := eksClient.DescribeCluster(&eks.DescribeClusterInput{
		Name: aws.String(clusterName),
	})

	if err != nil {
		t.Fatalf("Failed to retrieve EKS cluster: %v", err)
	}

	fmt.Printf("Cluster status: %s\n", aws.StringValue(clusterOutput.Cluster.Status))
}
