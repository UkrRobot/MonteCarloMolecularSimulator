# MonteCarloMolecularSimulator
Modeling by the Monte Carlo (MC) method does not require complicated mathematics because it comes almost from the first principles – probabilities of states or transitions of particles from one state into another are defined by the Boltzmann factor of energies (taken with the negative sign) in units of kT. Modeling by the MC method supposes consideration of the substance models, which are more complicated, than models that are analyzable in the framework of the modern theoretical physics. Statistical modeling by the MC method allows studying equilibrium states of systems. Kinetic modeling by the MC method allows analysis of the course of physical processes.
The essence of the Metropolis method consists of the generation of a set of consecutive configurations of system. On each step of this process, the following configuration is considered, which differs from the previous by the modification of one of the degrees of freedom. A new configuration can be accepted into the set or not, according to the procedure of the statistical trial. If by results of the statistical trial the new configuration is not accepted, the previous configuration is once again joined to the ensemble on this step. Thus, depending on its importance, the weight of the certain configuration in the ensemble can grow. Having the mode of walk in the system phase space defined, it is necessary to set transition probabilities between two configurations at each step of the walk. Thus, it is necessary to begin consideration that the system would go into the equilibrium state in the limiting case of total number of walks.
Procedure of the statistical trial in the Metropolis method consists of following: the new configuration is accepted in ensemble with the probability equal to ratio of the Gibbs weights (Boltzmann’s exponents) of the new and old configurations.
An essential and very important component of the Metropolis algorithm and thermostat algorithm is the generation of pseudorandom numbers. These numbers are termed pseudorandom, instead of random, as any generator of such numbers programmed on the computer has a finite period, after which these numbers start to repeat. It happens because the number of digits to the right of the decimal point in representation of real numbers on the computer is finite. The quality of the random numbers generator essentially influences the accuracy of evaluations by the MC technique. The main property of the Metropolis algorithm is that it “guides” the system into area of the most probable states in the phase space. The majority of configurations is skipped at the Markov process construction, and the average values of physical quantities are calculated taking into account the configurations that respond to the most probable states. Any starting configuration (any values of variables) can be used to construct the Markov chains. The outcomes should not depend on this choice: the system in equilibrium “forgets” about the history of establishing the equilibrium. However, at real calculations, the Markov time of reaching of typical equilibrium configurations, for which it is possible to realize measuring, can depend on the successful choice of the starting configuration.
In the thermostat algorithm on each step of the Markov time, one of the degrees of freedom is brought to the thermal equilibrium with the exterior “thermostat” having the temperature T; other degrees of freedom are fixed for this step. As a result, of the multiple recurring of such procedure for all degrees of freedom and for a long Markov time, establishing full thermodynamic equilibrium of the system with the thermostat occurs.

![alt text](https://github.com/UkrRobot/MonteCarloMolecularSimulator/blob/master/MonteCarlo.png)

This program was developed under the guidance of Professor A. Ovrutsky.
