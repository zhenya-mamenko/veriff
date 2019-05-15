import React from 'react';
import PropTypes from 'prop-types';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faUserFriends, faSuitcaseRolling } from '@fortawesome/free-solid-svg-icons';
import { Row, Col, Spinner, Button, Container } from 'react-bootstrap';
import './Card.css';

const Card = ({ data, button }) => {
	if (data) {
		let badges = data.benefits && data.benefits.length !== 0 ? [] : null;
		for (let i = 0; data.benefits && i < data.benefits.length; i++) {
			let benefit = data.benefits[i];
			if (benefit.indexOf("+") === 0) {
				benefit = benefit.substr(1);
				badges.push(<span key={ `badge${i}` } className="badge badge-success mr-1">{ benefit }</span>);
			}
		}
		let { price, oldPrice, onClick } = data;
		if (data.oldPrice)
			oldPrice = Math.floor(data.oldPrice);
		price = Math.floor(data.price);
		return (
			<Container className="mt-4 p-3 shadow rounded">
				<Row>
					<Col xs="12" md="6">
						<h4>
							{data.carName}
							<br />
							<small className="text-muted font-weight-light">{ "or similar " + data.carType }</small>
						</h4>
						<p className="mt-3 font-weight-bold">
							<FontAwesomeIcon icon={faUserFriends} size="lg" className="mr-2 text-secondary" />{data.passengers}
							<FontAwesomeIcon icon={faSuitcaseRolling} size="lg" className="mr-2 ml-5 text-secondary" />{data.bags}
						</p>
						{ badges &&
						<p>
							{badges}
						</p>
						}
					</Col>
					<Col xs="12" md="4">
						<img className="float-right mr-2" src={data.image} alt={data.carName} />
					</Col>
					<Col xs="12" md="2" className="p-2 border-left">
						<p className="h4 text-center mb-3">
							{ data.oldPrice && <small className="text-danger"><br /><del>${ oldPrice }</del></small> }
							${ price }
							<br /><small className="text-muted Card-small">Total price</small>
						</p>
						<p className="text-center">
							<Button
								as="input"
								value={ button }
								className="w-75"
								variant="info"
								onClick={ onClick }
							/>
						</p>
					</Col>
				</Row>
			</Container>
		);
	}
	else {
		return (<><Spinner animation="border" role="status" size="lg" /> Loading...</>);
	}
}

Card.propTypes = {
	data: PropTypes.object.isRequired,
	button: PropTypes.string.isRequired,
	onClick: PropTypes.func
};

export default Card;