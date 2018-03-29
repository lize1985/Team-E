import React from 'react';

export default function Accounts({
    accounts=[],
    OnSelectAccount
}){
    return (
        <div className="pure-menu sidebar">
            <span className="pure-menu-heading">Account Lists</span>

            <ul className="pure-menu-list">
                {
                    accounts.map(
                        account=> (
                            <li className="pure-menu-item" key={account} onClick = {OnSelectAccount}>
                                <a hred="#" className="pure-menu-link">{account}</a>
                            </li>
                        )
                    )

                }    
            </ul>

        </div>

    )

}
