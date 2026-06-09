resource "aws_security_group" "agent_sg" {
name = "agent-sg"

ingress {
from_port   = 22
to_port     = 22
protocol    = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

egress {
from_port   = 0
to_port     = 0
protocol    = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
}

resource "aws_instance" "jenkins_agent" {
  ami                    = "ami-0f58b397bc5c1f2e8"
  instance_type          = "t2.micro"
  key_name               = "healthcare-key"
  vpc_security_group_ids = [aws_security_group.agent_sg.id]

tags = {
Name = "jenkins-agent"
}
}

output "agent_public_ip" {
value = aws_instance.jenkins_agent.public_ip
}

output "agent_private_ip" {
value = aws_instance.jenkins_agent.private_ip
}
