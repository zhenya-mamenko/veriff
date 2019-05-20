import React, { useState } from 'react';
import PropTypes from 'prop-types';
import { Jumbotron, Container, Row, Col, Button } from 'react-bootstrap';
import Search from './Search';

const Home = ({ points, onButtonClick }) => {
	const [state, setState] = useState({
		disabled: true,
		dateFrom: new Date(),
		dateTo: new Date(),
		sameDropOff: true,
		fromPoint: 0,
		toPoint: 0,
	});

	return (
		<>
			<Container>
				<Jumbotron>
					<h1 className="display-2">Rent a Car!</h1>
					<p>
						Just sign up, proceed Veriff identification and drive to journey.
					</p>
					<Row>
						<Search points={ points } cols={3} onChange={ (disabled, searchState) => {
							const { dateFrom, dateTo, sameDropOff, fromPoint, toPoint } = searchState;
							setState({ disabled, dateFrom, dateTo, sameDropOff, fromPoint, toPoint });
							}
							}
						/>
					</Row>
					<Row>
						<Col className="pt-3">
							<Button
								as="input"
								variant="outline-secondary"
								size="lg"
								value="Search cars"
								disabled={ state.disabled }
								onClick={ () => onButtonClick(state) }
								/>
						</Col>
					</Row>
				</Jumbotron>
			</Container>
			<Container>
				<Row>

				</Row>
			</Container>
		</>
	);
}

Home.propTypes = {
	points: PropTypes.array.isRequired,
	onButtonClick: PropTypes.func.isRequired
};

export default Home;