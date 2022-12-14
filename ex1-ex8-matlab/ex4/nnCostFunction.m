function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m

X = [ones(m,1) X];
% for i = 1:m % over samples
%     y_vector = (y(i)==c); 
%     h_theta_x = sigmoid(Theta2*[1;sigmoid(Theta1* X(i,:)')]);
%     J = J + 1/m .* (-y_vector*log(h_theta_x) - (1-y_vector)*log(1-h_theta_x));
% end
a1 = X;
z2 = a1*Theta1'; % 5000*25
a2 = sigmoid(z2);% 5000*25
a2 = [ones(m,1) a2]; % 5000*26
z3 = a2*Theta2'; % 5000*10
a3 = sigmoid(z3); % 5000*10
y_vector = (y==[1:num_labels]);
J = 1/m * sum(-y_vector.*log(a3) - (1 - y_vector).*log(1 - a3),'all');% Notice here should be dot product, instead of matrix multiplication.

% Regularized 
reg_J = lambda/(2*m)*(sum(Theta1(:,2:end).^2,'all') + sum(Theta2(:,2:end).^2,'all'));
J = reg_J + J;

% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
for t = 1:m
    a1 = X(t,:); % 1*401, Set the input layer's values to the t-th training example
    z2 = a1*Theta1'; %1*25, a feedforward pass for layers 2
    a2 = [1 sigmoid(z2)]; % 1*26, add 1 for bias
    z3 = a2*Theta2'; % 1*10, a feedforwad for layers 3
    a3 = sigmoid(z3); % 1*10
    
    delta3 = (a3 - y_vector(t,:)); % 1*10, the errors in layers 3
    delta2 = delta3*Theta2.*[1 sigmoidGradient(z2)]; % 1*26, the errors in layers 2
    Theta2_grad = Theta2_grad + delta3'*a2; % 10*26
    Theta1_grad = Theta1_grad + delta2(2:end)'*a1; % 25*401
end
Theta2_grad = 1/m * Theta2_grad;
Theta1_grad = 1/m * Theta1_grad;
    

% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%
Theta2_grad = Theta2_grad + lambda/m*[zeros(size(Theta2,1),1) Theta2(:,2:end)];
Theta1_grad = Theta1_grad + lambda/m*[zeros(size(Theta1,1),1) Theta1(:,2:end)];


















% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
