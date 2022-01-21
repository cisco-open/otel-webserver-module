#include "Dummy.h"

MyAgent::MyAgent(const std::string& name)
	: m_AgentName(name)
{

}

void MyAgent::Initialise(std::shared_ptr<IAgentDep> myAgentDep)
{
	m_AgentDep = myAgentDep;
	//m_AgentDep.reset(myAgentDep);
	//m_AgentIntDep.reset(new MyAgentIntDep());
}

int MyAgent::WorkOnAgentDep(int arg)
{
	auto value = m_AgentDep->FirstWork(arg);
	if (value.empty())
	{
		return 0;
	}
	value = m_AgentDep->FirstWork(arg);
	auto ret = m_AgentDep->SecondWork(value);
	int v = ret == true ? 100 : 50;
	return v;
}