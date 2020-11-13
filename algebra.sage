import numpy as np

# Probability of winning each game.
def ix(a, b):
    return b + 3 * a

# Player 1 win prob for each game.
games = list(var(f'g_{i}{j}') for i in range(3)
                 for j in range(3))
# Player 1 win prob for each match - index is ban.
matches = list(var(f'm_{i}{j}') for i in range(3)
                   for j in range(3))
# Probability of each of player 1's bans.
p1_bans = list(var(f'b1_{i}') for i in range(3))
p2_bans = list(var(f'b2_{i}') for i in range(3))

# Equations for match win prob.
# Assumes each player will choose their first deck with probability 1/2
# since that's always an equilibrium.
match_eqs = []
for i in range(3):
    for j in range(3):
        # Allowed decks for each player.
        p1 = [0, 1, 2]
        p2 = [0, 1, 2]
        p1.remove(j)
        p2.remove(i)
        eq = matches[ix(i, j)] == (1/4) * (
            sum(games[ix(p1[ii], p2[jj])] * (1-(1-games[ix(p1[1-ii], p2[jj])]) *
                                             (1-games[ix(p1[1-ii], p2[1-jj])]))
                + (1-games[ix(p1[ii], p2[jj])]) * games[ix(p1[ii], p2[1-jj])] *
                           games[ix(p1[1-ii], p2[1-jj])]
                           for ii in range(2)
                           for jj in range(2)))
        match_eqs.append(eq)

# Get the value of each of my p2's bans given p1 ban probs.
vals = [
    sum(p1_bans[i] * (1 - matches[ix(i, j)]) for i in range(3))
    for j in range(3)]
# Probabilities assuming an equilibrium exists.
ban_eqs = [vals[0] == vals[1], vals[0] == vals[2], sum(p1_bans) == 1]

def get_game_prob_eqs():
    ret = []
    matrix = np.array([[16,5,6],[3,6,8],[2,13,4]]) / 16
    for i in range(3):
        for j in range(3):
            ret.append(games[ix(i, j)] == matrix[i, j])
    return ret

print(solve(match_eqs + ban_eqs + get_game_prob_eqs(),
            *(p1_bans + matches + games),
            solution_dict=True))
