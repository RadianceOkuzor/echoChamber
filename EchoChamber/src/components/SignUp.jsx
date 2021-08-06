import React, { Component } from 'react';
import { createUserProfileDocument } from '../firebase';
import {auth} from '../firebase'


class SignUp extends Component {
  state = { email: '', password: '' };

  handleChange = event => {
    const { name, value } = event.target;

    this.setState({ [name]: value });
  };

  handleSubmit = async event => {
    event.preventDefault();

   const{email, password} = this.state
   try{
     const{user} = await auth.createUserWithEmailAndPassword(
       email,
       password,
     );

 createUserProfileDocument(user)
   } catch (error){
     console.error(error)
   }
   this.setState({ email: '', password: '' });
  };

  render() {
    const { email, password } = this.state;

    return (
      <form className="SignUp" onSubmit={this.handleSubmit}>
        <h2>Sign Up</h2>
      
        <input
          type="email"
          name="email"
          placeholder="Email"
          value={email}
          onChange={this.handleChange}
        />

        <input
          type="password"
          name="password"
          placeholder="Password"
          value={password}
          onChange={this.handleChange}
        />
        <input type="submit" value="Sign Up" />
      </form>
    );
  }
}

export default SignUp;
