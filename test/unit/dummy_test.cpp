#include <gtest/gtest.h>
#include <gmock/gmock.h>
#include "Dummy.h"
#include "mocks/mock_dummy.h"

using ::testing::Return;

/*class MockMyAgentDep : public IAgentDep
{
public:
	MOCK_METHOD(std::string, FirstWork, (int arg));
	MOCK_METHOD(bool, SecondWork, (const std::string& value));
};*/

TEST(MyAgentTest, MyAgent_Create)
{
	std::string name{"agentName"};
	MyAgent myAgent(name);
	ASSERT_EQ(name, myAgent.GetAgentName());
}

TEST(MyAgentTest, MyAgent_WorkOnAgentDep_Return_Zero)
{
	std::string name{"agentName"};
	MyAgent myAgent(name);
	ASSERT_EQ(name, myAgent.GetAgentName());

	std::shared_ptr<MockMyAgentDep> myAgentDep(new MockMyAgentDep());
	myAgent.Initialise(myAgentDep);

	using ::testing::Ne;
	EXPECT_CALL(*myAgentDep, FirstWork(Ne(10))).Times(0);
	EXPECT_CALL(*myAgentDep, FirstWork(10)).
						WillOnce(Return(""));

	ASSERT_EQ(0, myAgent.WorkOnAgentDep(10));
}

TEST(MyAgentTest, MyAgent_WorkOnAgentDep_Return_Hundred)
{
	std::string name{"agentName"};
	MyAgent myAgent(name);
	ASSERT_EQ(name, myAgent.GetAgentName());

	std::shared_ptr<MockMyAgentDep> myAgentDep(new MockMyAgentDep());
	myAgent.Initialise(myAgentDep);

	using ::testing::Ne;
	EXPECT_CALL(*myAgentDep, FirstWork(Ne(10))).Times(0);
	EXPECT_CALL(*myAgentDep, SecondWork("Dummy2")).
						WillOnce(Return(true));
	EXPECT_CALL(*myAgentDep, FirstWork(10)).
						WillOnce(Return("Dummy1")).
						WillOnce(Return("Dummy2"));


	ASSERT_EQ(100, myAgent.WorkOnAgentDep(10));
}
