/*
   Copyright 2020 AppDynamics.
   All rights reserved.
   This is dummy class to demo to write test cases using gtest and gmock.
   Should be removed once actual implementation starts

*/

#ifndef __dummy_h
#define __dummy_h

#include <string>
#include <memory>

// Ideally these classes should be in different file.
class IAgentDep {
public:
	virtual ~IAgentDep() {}
	virtual std::string FirstWork(int arg) = 0;
	virtual bool SecondWork(const std::string& value) = 0;
};

class MyAgentDep : public IAgentDep {
public:
	~MyAgentDep() {}
	std::string FirstWork(int arg) override { return "" ;}
	bool SecondWork(const std::string& value) override {return true; }
};

// Class to be tested.
class IAgent {
public:
	virtual ~IAgent(){}
	virtual std::string& GetAgentName() = 0;
	virtual void Initialise(std::shared_ptr<IAgentDep> myAgentDep) = 0;
	virtual int WorkOnAgentDep(int arg) = 0;
	//virtual int WorkOnAgentIntDep(int arg) = 0;
};

class MyAgent : public IAgent {
public:
	MyAgent(const std::string& name);
	std::string& GetAgentName() override { return m_AgentName; }
	void Initialise(std::shared_ptr<IAgentDep> myAgentDep) override;
	int WorkOnAgentDep(int arg) override;
	//int WorkOnAgentIntDep(int arg) override ;

private:
	std::string m_AgentName;
	std::shared_ptr<IAgentDep> m_AgentDep;
};

#endif