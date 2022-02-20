# Enarx Electronic Voting Protection

**Example case:**

We explore technological experiments with Enarx. Showcase is Remote Electronic Voting (REV). Ideally, electronic voting should provide these properties and many more:

1. Ballot Privacy: No outside observer can determine the contents of a specific vote.
2. Censorship-Resistance: No party, even the administrator of an election, can censor a valid vote.
3. Non-Repudiation: No party can modify or erase a vote that has been cast.
4. Correct Execution: No party can forge a false tally of votes.

**Problem:**

The system administrator observers the votes and modifies them during the election.

**Solution:**

Enarx keep prevents the system administrator to observe and interfere with the election software.

# Attack: Manipulation attack when election software is executed normally

Election software (vote 1 or 2, 9 votes):

```sh
$ bash run_elections.sh normal
Enter a vote: 1 or 2.
2
Vote 1=2
Vote 2=1
Vote 3=2
Vote 4=1
Vote 5=2
```

Election manipulation:

```sh
$ sudo bash stealvotes.sh voting-machine
Change the vote 1
Vote 1=2 --> Vote 1=1
Change the vote 3
Vote 3=2 --> Vote 3=1
Change the vote 5
Vote 5=2 --> Vote 5=1
```

# Attack: Run Enarx Keep without CPU hardware protection and search voting status

Election software (vote 1 or 2, 9 votes):

```sh
$ bash run_elections.sh kvm
```

Search votes:

```sh
$ sudo bash vote_search.sh voting-machine
Vote 1=1
Vote 2=2
Vote 3=1
...
```

# Protected from the attacks: Run election software inside Enarx Keep with CPU hardware protection

Election software (vote 1 or 2, 9 votes):

```sh
$ bash run_elections.sh sev
or
$ bash run_elections.sh sgx
```

Search votes:

```sh
$ sudo bash vote_search.sh voting-machine
```
